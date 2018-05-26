module Api::V1::GradeHelper
  require 'net/http'

  def request_hunau_api_get_stuGrades(userId)
    uri_str = Settings.hunauapi.service_host +
              Settings.hunauapi.service_post_endpoint +
              Settings.hunauapi.service_grades_endpoint

    sign = "userId=#{userId}CardCode=#{userId}XN=XQ=#{ENV['HUNAU_API_PARAMS_AK']}"
    sign = Digest::MD5.hexdigest sign

    params = { callback: Settings.hunauapi.callback,
               userId: userId,
               CardCode: userId,
               XN: '',
               XQ: '',
               ak: ENV['HUNAU_API_PARAMS_AK'],
               sign: sign,
               _: ENV['HUNAU_API_PARAMS_GRADE__'] }

    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def handle_grade(userId)
    strGrades = request_hunau_api_get_stuGrades(userId)
    strGrades = strGrades.gsub!('loadCJ_JsonpCallback(', '').chop!
    strGrades = JSON.parse(strGrades)

    if strGrades["Status"].to_i == 1
      strGrades["rList"].each do |grades|
        StuGrade.find_or_create_by!(xn: grades["XN"],
                         xq: grades["XQ"],
                         xh: grades["XH"],
                         xm: grades["XM"],
                         kcmc: grades["KCMC"],
                         xf: grades["XF"],
                         cj: grades["CJ"],
                         kcxz: grades["KCXZ"] )
      end
    end
  end

end
