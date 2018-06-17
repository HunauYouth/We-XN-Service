class Api::V1::BindStuUserController < Api::BaseController

  require 'uri'
  require 'net/http'

  include Api::ApiHelper

  def index
    user = StuUser.find_by(schno: private_params["stu_number"])
    if user
      # self.current_user = user
      if user.wechat_open_id.nil?
        wechat_user_flag = JSON.parse(request_wechat_login_api(params['code']))
        user.update_columns(wechat_open_id: wechat_user_flag["openid"],
                            authentication_token: wechat_user_flag["openid"] + wechat_user_flag["session_key"])
      end
      render :json => {
        status: 'success',
        message: '绑定成功',
        data: user
      }
    else
      res = request_hunau_api_login(private_params["stu_number"],
                                    private_params["stu_password"])
      login_info_xml = Nokogiri::XML res
      login_info = JSON.parse(login_info_xml.child.child.to_s)

      login_status = login_info["status"].to_i
      if login_status.zero?
        render :json => {
          status: 'failed',
          message: '绑定失败',
          message_detail: login_info["Msg"]
        }
      else
        wechat_user_flag = JSON.parse(request_wechat_login_api(params['code']))
        wechat_user_flag = "" if wechat_user_flag["errcode"].present?

        user_info = login_info["Userinfo"]
        user_info = user_info.map { |k, v| [k.downcase, v] }.to_h
        user_info["user_type"] = user_info["type"]
        user_info.delete_if { |k, v| k == "type" }
        user_info["wechat_open_id"] = wechat_user_flag["openid"]
        user_info["authentication_token"] = wechat_user_flag["openid"] + wechat_user_flag["session_key"]
        user = StuUser.new(user_info)

        if user.save
          render :json => {
            status: 'success',
            message: '绑定成功',
            data: user
          }
        else
          render :json => {
            status: 'failed',
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
