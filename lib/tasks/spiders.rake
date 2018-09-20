namespace :spiders do

  desc 'Spider => 抓取所有学术活动'
  task get_xshd: :environment do
    @start_url = "http://www.hunau.edu.cn/xshd/"
    get_lists(@start_url, 'get_all')
  end

  desc 'Spider => 更新学术活动'
  task update_xshd: :environment do
    @start_url = "http://www.hunau.edu.cn/xshd/"
    get_lists(@start_url, 'update')
  end

  desc 'Spider => 抓取办公电话'
  task get_office_tel: :environment do
    @start_url = "http://www.hunau.edu.cn/ndgk/lxwm/bgdh/201611/t20161114_166812.html"
    get_tel(@start_url)
  end

  def get_tel(url)
    doc = Nokogiri::HTML(open(url))

    tel_element = doc.css('.tel_right_style > div')
    tel_element.xpath('//br').remove
    tel_obj = {}
    c_name = ''
    tel_element.children.each do |tel_e|
      if tel_e.node_name == 'a'
        c_name = tel_e.text()
        tel_obj[c_name] = {}
        next
      end
      next if tel_e.text() == "\n"
      str = tel_e.text.strip.gsub('…', '-').split('-')
      tel_obj[c_name][str.first] = str.last.delete('.')
    end

    current_company_code = Company.maximum("code")
    current_dep_id = Department.maximum('depid')
    tel_obj.each do |k, val|
      current_company_code += 1
      Company.find_or_create_by(name: k, code: current_company_code)
      val.each do |d_k, d_v|
        current_dep_id += 1
        Department.find_or_create_by(depname: d_k, depid: current_dep_id, comid: current_company_code, tell: d_v)
      end
    end
  end

  def get_lists(url, mode = 'update')
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

    if next_page_url.present? && next_page_text == '下一页' && mode == 'get_all'
      get_lists(next_page_url, 'get_all')
    else
      p '*' * 123
    end
  end

  def get_content(url)
    doc = Nokogiri::HTML(open(url))
    item = doc.xpath('//div[@class="about_detail"]')
    title = item.xpath('h2').text()
    date = Time.parse(item.xpath('div[@class="details-con"]/div[@class="details_info"]').text().gsub('时间:', '').strip).to_i
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
