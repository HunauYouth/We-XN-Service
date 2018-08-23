class Api::V1::NewsController < Api::BaseController
  def index
    @news = News.all.select("id, title, summary, addtime, news_id")

    if params['category'] == 'general'
      @news = @news.general
    elsif params['category'] == 'support'
      @news = @news.support_notice
    elsif params['category'] == 'xshd'
      @news = @news.xshd
    end
    @news = @news.page(params['page']).per(params['per'])
  end

  def show
    @news = News.find(params['id'])
  end
end
