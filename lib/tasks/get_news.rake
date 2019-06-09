namespace :get_news do
  require 'net/http'
  require 'rexml/document'
  include REXML

  desc 'Get All News'
  task get_all_news_from_hunauapi: :environment do
    counter = 0
    235.times do
      pages = { index: counter, size: 20 }
      news_list = request_hunau_api_get_news_list(pages, 5)
      handle_news_list(news_list)
      get_news_content
      counter += 1
      sleep(3.second)
      puts '*'
    end
    puts "Got" + counter  + "Times"
  end

  desc 'Get Newest News'
  task get_newest_news: :environment do
    pages = { index: 0, size: 10 }
    news_list = request_hunau_api_get_news_list(pages, 5)
    handle_news_list(news_list)
    get_news_content
    puts '*'
  end

  desc '后勤通知'
  task get_support_notice: :environment do
    page = { index: 0, size: 10 }
    support_notices = request_hunau_api_get_news_list(page, 48)
    xml_doc = Nokogiri::XML(support_notices)
    news = xml_doc.xpath('//new')

    news.each do |n|
      news_id = n.xpath('id').text()
      News.find_or_create_by(news_id: news_id,
                              title: n.xpath('Title').text(),
                              summary: n.xpath('summary').text(),
                              addtime: Time.parse(n.xpath('addtime').text()).to_i,
                              pic_path: URI.unescape(n.xpath('Pic').text()),
                              big_pic_path: URI.unescape(n.xpath('bigPic').text()),
                              category: 1
                             )
    end
    get_news_content
  end

  desc '初始化原新闻分类'
  task init_news_category: :environment do
    News.where.not(category: 1).find_in_batches do |news|
      news.each { |n| n.update_columns(category: 0) }
    end
  end

  desc 'addtime字段转为时间戳'
  task convert_addtime_to_timestamp: :environment do
    News.all.find_in_batches do |news|
      news.each do |n|
        next unless n.addtime.include?('/')
        n.update_columns( addtime: Time.parse(n.addtime).to_i )
      end
    end
  end

  def request_hunau_api_get_news_list(pages, type = 5)
    uri_str = Settings.hunauapi.service_host +
      Settings.hunauapi.service_endpoint +
      Settings.hunauapi.get_news_path

    params = { res: 20,
               id: ENV['HUNAU_API_PARAMS_NEWS_ID'],
               vid: ENV['HUNAU_API_PARAMS_VID'],
               Access_Token: ENV['HUNAU_API_PARAMS_AK'],
               type: type,
               pageindex: pages[:index],
               pagesize: pages[:size] }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def handle_news_list(news_list)
    xmldoc = Nokogiri::XML(news_list)

    xmldoc.xpath("Response/News/new").each do |e|
      news = News.new(news_id: e.xpath('id').children.text.strip,
                      title: e.xpath('Title').children.text.strip,
                      isuser: e.xpath('IsUser').children.text.strip,
                      summary: e.xpath('summary').children.text.strip,
                      addtime: Time.parse(e.xpath('addtime').children.text.strip).to_i,
                      category: 0,
                      pic_path: URI::decode(e.xpath('Pic').children.text.strip),
                      big_pic_path: URI::decode(e.xpath('bigPic').children.text.strip) )
      if news.save
        puts '.'
      else
        puts 'x'
      end
    end
  end

  def get_news_content
    News.where(content: nil).each do |news|
      news_content = JSON.parse(request_news_content_api(news.news_id))["RList"]
      content = Hash[*news_content]
      unless content.empty?
        if content['Content'].encoding.to_s != "UTF-8"
          content = content["Content"].force_encoding 'utf-8'
          #content = content.encode
        end
        news.update_columns(content: content['Content'])
      end
    end
  end

  def request_news_content_api(news_id)
    uri_str = Settings.hunauapi.service_news_host +
      Settings.hunauapi.service_news_endpoint

    user_id = StuUser.first.cardcode
    params = { action: 'LoadData',
               id: news_id,
               uid: user_id,
               sign: ENV['HUNAU_API_PARAMS_AK'],
               Ntype: '' }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

end
