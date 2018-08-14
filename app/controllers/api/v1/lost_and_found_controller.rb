class Api::V1::LostAndFoundController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    data = LostAndFound.order(id: :desc).page(params['page']).per(params['per'])
    if params['category'] == 'lost'
      data = data.lost
    elsif params['category'] == 'found'
      data = data.found
    end

    render :json => {
      status: 200,
      message: 'success',
      data: {
        page: {
          current_page: params[:page].to_i.zero? ? 1 : params[:page].to_i,
          page_size: params[:per].to_i.zero? ? News::DEFAULT_PER : params[:per],
          total_pages: data.total_pages,
          total: data.count
        },
        lost_founds: data
      }
    }
  end

  def create
    l_f = LostAndFound.new(l_f_params)
    if l_f.save
      render :json => {
        status: 200,
        message: 'success',
        data: l_f
      }
    else
      render :json => {
        status: 400,
        message: 'failed',
        error: l_f.errors.messages
      }
    end
  end

  private
    def l_f_params
      l_f_params = params.require(:l_f_p).permit(:stu_user_id, :title, :describe, :images, :category, :tel, :status)
      l_f_params[:category] = l_f_params[:category].to_i
      l_f_params
    end
end
