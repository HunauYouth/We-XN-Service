class Api::V1::WxLoginController < ApplicationController
  include Api::ApiHelper

  def index
    wx_login_res = JSON.parse(request_wechat_login_api(params['code']))
    stu_user = StuUser.find_by(wechat_open_id: wx_login_res["openid"])
    if stu_user
      render :json => {
        status: 200,
        message: '请求成功',
        data: stu_user.as_json
      }
    else
      render :json => {
        status: 400,
        message: '登录失败, 未查询到绑定信息'
      }
    end
  end
end
