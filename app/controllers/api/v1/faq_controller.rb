class Api::V1::FaqController < ApplicationController
  def index
    faqs = Faq.all

    render :json => {
      status: 200,
      message: 'success',
      data: faqs
    }
  end
end
