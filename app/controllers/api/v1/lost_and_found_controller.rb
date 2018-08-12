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
      params.require(:data).permit(:stu_user_id, :name, :describe, :pic, :category, :status)
    end
end
