class Api::V1::GetBrowsController < ApplicationController

  include Api::ApiHelper

  def index
    queryParams = {
      cardid: params['cardid'],
      id: params['id'],
      code: params['code'],
      bData: params['bData'],
      eData: params['eData'],
      pageNum: params['pageNum'],
      pageSize: params['pageSize'],
      pageindex: params['pageindex'],
      SessionId: params['SessionId'].empty? ? '' : params['SessionId'],
      ak: ENV['HUNAU_API_PARAMS_AK']
    }
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_brows
    res = request_helper(queryParams, uri_str)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: res
    }
  end

  def today_brows
    queryParams = {
      ak: ENV['HUNAU_API_PARAMS_AK'],
      id: params['id'],
      CardId: params['cardid'],
      Code: 15,
      pageSize: 10,
      pageNum: 0
    }

    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_today_borrows

    res = request_helper(queryParams, uri_str)

    render :json => {
      status: 'success',
      message: '请求成功',
      data: res
    }
  end

  def loss
    queryParams = {
      id: params['id'],
      CardId: params['CardId'],
      pwd: params['pwd'],
      ak: ENV['HUNAU_API_PARAMS_AK']
    }
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_endpoint +
              Settings.hunauapi.get_loss
    res = request_helper(queryParams, uri_str)
    render :json => {
      status: 'success',
      message: '请求成功',
      data: res
    }
  end
end
