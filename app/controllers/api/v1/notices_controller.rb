class Api::V1::NoticesController < ApplicationController
  def index
    notice = Notice.active.first
    if notice.present?
      render :json => {
        status: 200,
        message: 'success',
        data: notice
      }
    else
      render :json => {
        status: 400,
        message: 'failed'
      }
    end
  end
end
