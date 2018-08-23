namespace :spiders do
  require 'watir'

  desc 'Spider => 学术活动'
  task get_xshd: :environment do
    @start_url = "http://www.hunau.edu.cn/xshd/"
    get_lists(@start_url)
  end

  def get_lists(url)
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto url
    #browser = Watir::Browser.start url
    xshd_list_x_path = '/html/body/div/div[5]/div[2]/div[2]/div/div[2]/ul/li'
    next_page_x_path = '//*[@id="fenye"]/table/tbody/tr/td/a[@class="next"]'

    doc = Nokogiri::HTML.parse(browser.html)
    browser.close
    next_page_url = @start_url + doc.xpath(next_page_x_path).xpath('@href').text()
    next_page_text = doc.xpath(next_page_x_path).text()
    lists = doc.xpath(xshd_list_x_path)

    ex_url = lists[0].xpath("a/@href").text().sub('./', @start_url)
    get_content(ex_url)
    lists.each do |l|
      item_url = l.xpath("a/@href").text().sub('./', @start_url)
      get_content(item_url)
    end

    puts '#' * 123
    puts next_page_url
    puts '#' * 123

    if next_page_url.present? && next_page_text == '下一页'
      get_lists(next_page_url)
    else
      p '*' * 123
    end
  end

  def get_content(url)
    doc = Nokogiri::HTML(open(url))
    item = doc.xpath('//div[@class="about_detail"]')
    title = item.xpath('h2').text()
    date = item.xpath('div[@class="details-con"]/div[@class="details_info"]').text().gsub('时间:', '').strip
    content = item.xpath('div[@class="details-con"]/div[@class="TRS_Editor"]')
    if content.css('div.TRS_Editor> p> img').present?
      uri = URI.parse(url)
      path_arr = uri.path.split('/')
      path_arr.pop
      img_src = uri.host + path_arr.join('/') + '/'
      content.css('div.TRS_Editor> p> img').attr('src').value = 'http://' + content.css('div.TRS_Editor> p> img').attr('src').value.gsub('./', img_src)
    end
    content_html = content.to_html
    category = 2
    News.find_or_create_by(title: title, addtime: date, content: content_html, category: category, source_link: url)
  end
end
