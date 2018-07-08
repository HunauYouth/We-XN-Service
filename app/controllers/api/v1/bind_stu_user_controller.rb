class Api::V1::BindStuUserController < Api::BaseController

  require 'uri'
  require 'net/http'

  include Api::ApiHelper

  def index
    user = StuUser.find_by(schno: private_params["stu_number"])
    if user
      if user.wechat_open_id.nil? && params['code'].present?
        wechat_user_flag = JSON.parse(request_wechat_login_api(params['code']))
        user.update_columns(wechat_open_id: wechat_user_flag["openid"],
                            authentication_token: wechat_user_flag["openid"] + wechat_user_flag["session_key"])
      end
      render :json => {
        status: 200,
        message: '绑定成功',
        data: user.as_json
      }
    else
      res = request_hunau_api_login(private_params["stu_number"], private_params["stu_password"])
      login_flag = res["status"]

      if login_flag.to_i.zero?
        render :json => {
          status: 400,
          message: '绑定失败',
          message_detail: res["msg"]
        }
      else
        if params['code'].present?
          wechat_user_flag = JSON.parse(request_wechat_login_api(params['code']))
          wechat_open_id = wechat_user_flag["openid"]
          authentication_token = wechat_user_flag["openid"] + wechat_user_flag["session_key"]
        end

        user_info = res["userinfo"].transform_keys!(&:downcase)
        user_info['user_type'] = user_info.delete('type')
        user_info["wechat_open_id"] = wechat_open_id || nil
        user_info["authentication_token"] = authentication_token || nil
        user = StuUser.new(user_info)

        if user.save
          render :json => {
            status: 200,
            message: '绑定成功',
            data: user.as_json
          }
        else
          render :json => {
            status: 400,
            message: '绑定失败',
            errors: user.errors.messages
          }
        end
      end
    end
  end

  private
    def private_params
      params.require(:stu_user).permit(:stu_number, :stu_password)
    end
end
