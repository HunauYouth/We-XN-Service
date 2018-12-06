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

  def feed
    url = params['url']
    doc = Net::HTTP.get_response(URI.parse(url)).body
    render :json => {
      status: 200,
      message: 'success',
      data: Hash.from_xml(doc).as_json
    }
  end
end
