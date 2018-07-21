module ApplicationHelper
  def request_helper(params, uri_str)
    uri = URI.parse(uri_str)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
    xmldoc = Nokogiri::XML(res.body)
    JSON.parse(xmldoc.child.child)
  end
end
