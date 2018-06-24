class Api::V1::BookRetrievalController < ApplicationController

  include Api::ApiHelper

  def hot_keys
    str_params = '[Lib={{hunau}}][StArea={{StWeek}}][UniSess={{}}][SessLib={{hunau}}][SessFun={{wap}}][SessPrd={{book}}][SessType={{3}}]'

    hot_keys_params = {
      a: str_params,
      z3: '',
      z4: 11,
      z5: ''
    }

    url = URI(Settings.FindBook.service_host + Settings.FindBook.hot_keys_path)
    result = request_zhaobenshu(url, hot_keys_params)

    if result[:error].to_i.zero?
      result[:stvisitkey_ifa_GetList_list1].each do |item|
        item[:RowNo] = base64_2_utf8_helper(item[:RowNo])
        item[:IfLib] = base64_2_utf8_helper(item[:IfLib])
        item[:Keys] = base64_2_utf8_helper(item[:Keys])
        item[:StCnt] = base64_2_utf8_helper(item[:StCnt])
      end

      render :json => {
        code: 200,
        status: 'success',
        message: '请求成功',
        data: result[:stvisitkey_ifa_GetList_list1]
      }
    end
  end

  def book_search
    keys = params["book_name"]
    page_no = params["page_no"] || 1
    str_params = "[Lib={{hunau}}][SublibSn={{0}}][Keys={{#{keys}}}][_PageNo={{#{page_no}}}][UniSess={{}}][SessLib={{hunau}}][SessFun={{wap}}][SessPrd={{book}}][SessType={{3}}]"

    search_params = {
      a: str_params,
      z3: '',
      z4: 11,
      z5: ''
    }
    url = URI(Settings.FindBook.service_host + Settings.FindBook.book_search_path)
    result = request_zhaobenshu(url, search_params)

    if result[:error].to_i.zero?
      result[:find_ifa_FindFullPage_list1].each do |item|
        item[:RowNo] = base64_2_utf8_helper(item[:RowNo])
        item[:CtrlNo] = Base64.decode64(item[:CtrlNo])
        item[:CtrlRd] = Base64.decode64(item[:CtrlRd])
        item[:BookNo] = base64_2_utf8_helper(item[:BookNo])
        item[:BookRd] = base64_2_utf8_helper(item[:BookRd])
        item[:IsoCount] = base64_2_utf8_helper(item[:IsoCount])
        item[:SublibDis] = base64_2_utf8_helper(item[:SublibDis])
        item[:Title] = base64_2_utf8_helper(item[:Title])
        item[:Isbn] = base64_2_utf8_helper(item[:Isbn])
        item[:Author] = base64_2_utf8_helper(item[:Author])
        item[:Publish] = base64_2_utf8_helper(item[:Publish])
        item[:PublishC] = base64_2_utf8_helper(item[:PublishC])
        item[:PublishD] = base64_2_utf8_helper(item[:PublishD])
        item[:JdCover] = base64_2_utf8_helper(item[:JdCover])
      end

      render :json => {
        code: 200,
        status: 'success',
        message: '请求成功',
        data: {
          pages: {
            FgData: result[:FgData],
            PageCount: result[:PageCount],
            FindCount: result[:FindCount],
            FindTime: result[:FindTime]
          },
          lists: result[:find_ifa_FindFullPage_list1]
        }
      }
    end
  end

  def book_detail
    #ctrl_no = params['ctrl_no']
    ctrl_rd = params['ctrl_rd']

    str_params = "[Lib={{hunau}}][CtrlRd={{#{ctrl_rd}}}][UniSess={{}}][SessLib={{hunau}}][SessFun={{wap}}][SessPrd={{book}}][SessType={{3}}]"
    detail_params = {
      a: str_params,
      z3: '',
      z4: 11,
      z5: ''
    }

    url = URI(Settings.FindBook.service_host + Settings.FindBook.book_detail_path)
    result = request_zhaobenshu(url,detail_params)

    result[:Room] = Base64.decode64(result[:Room]) if !result[:Room].nil?
    result[:Barcode] = Base64.decode64(result[:Barcode]) if !result[:Barcode].nil?
    result[:Callno] = Base64.decode64(result[:Callno]) if !result[:Callno].nil?
    result[:Status] = Base64.decode64(result[:Status]) if !result[:Status].nil?

    render :json => {
      code: 200,
      status: 'success',
      message: '请求成功',
      data:  {
        room: result[:Room],
        barcode: result[:Barcode],
        callno: result[:Callno],
        status: result[:Status]
      }
    }
  end

  def lib_collection
    url = URI("http://59.41.253.14:7778/Find/find_ifa_GetOpacColl2.aspx?a=hunau&u=[SessLib=hunau][SessFun=wap][SessPrd=book]&b=#{params['ctrl_no']}&z3=&z5=&z4=11")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    hash = eval(response.read_body.force_encoding('utf-8'))
    if hash[:error].to_i.zero?
      render :json => {
        code: 200,
        status: 'success',
        message: '请求成功',
        data: hash[:find_ifa_GetOpacColl2_list1]
      }
    else
      render :json => {
        code: 400,
        status: 'failed',
        message: '请求失败'
      }
    end
  end

  def lib_site
    url = URI("http://59.41.253.14:7778/Find/find_ifa_GetSiteColl.aspx?a=hunau&u=[SessLib=hunau][SessFun=wap][SessPrd=book]&b=#{params['ctrl_rd']}&c=#{params['ctrl_no']}&z3=&z4=11&z5=")
    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    hash = eval(response.read_body.force_encoding('utf-8'))
    if hash[:error].to_i.zero?
      hash[:find_ifa_GetSiteColl_list1].each do |item|
        item[:Room] = base64_2_utf8_helper(item[:Room])
        item[:Callno] = (item[:Callno])
        item[:Callno1] = Base64.decode64(item[:Callno1])
        item[:Callno2] = Base64.decode64(item[:Callno2])
        item[:Sublib] = base64_2_utf8_helper(item[:Sublib])
        item[:Room2] = base64_2_utf8_helper(item[:Room2])
        item[:Site] = base64_2_utf8_helper(item[:Site])
        item[:SiteL] = base64_2_utf8_helper(item[:SiteL])
        item[:SitePJ] = base64_2_utf8_helper(item[:SitePJ])
        item[:CollTotal] = Base64.decode64(item[:CollTotal])
      end
      hash[:find_ifa_GetSiteColl_list2].each do |item|
        item[:Room] = base64_2_utf8_helper(item[:Room])
        item[:Callno] = Base64.decode64(item[:Callno])
        item[:Barcode] = Base64.decode64(item[:Barcode])
        item[:Status] = Base64.decode64(item[:Status]).force_encoding('utf-8').delete!('<br>')
      end
      render :json => {
        code: 200,
        status: 'success',
        message: '请求成功',
        data: {
          site: hash[:find_ifa_GetSiteColl_list1],
          collection: hash[:find_ifa_GetSiteColl_list2]
        }
      }
    end
  end
end
