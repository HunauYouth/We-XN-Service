class Api::V1::LostAndFoundController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    l_f = LostAndFound.new(l_f_params)
    if l_f.save!
      render :json => {
        status: 200,
        message: '创建成功',
        data: l_f
      }
    else
      render :json => {
        status: 400,
        message: '创建失败',
        error: l_f.errors.message
      }
    end
  end

  private
    def l_f_params
      l_f_params = params.require(:l_f_p).permit(:stu_user_id, :name, :describe, :images, :category, :status)
      l_f_params[:stu_user_id] = l_f_params[:stu_user_id].to_i
      l_f_params[:category] = l_f_params[:category].to_i
      l_f_params[:status] = l_f_params[:status].to_i
      l_f_params
    end
end
