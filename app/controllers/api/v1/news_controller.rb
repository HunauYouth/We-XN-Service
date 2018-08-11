class Api::V1::NewsController < Api::BaseController
  def index
    @news = News.select("id, title, summary, addtime, news_id").order(id: :desc).page(params['page']).per(params['per'])
  end

  def show
    @news = News.find(params['id'])
  end
end
