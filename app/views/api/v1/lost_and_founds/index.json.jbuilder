json.data do
  json.set! :page do
    json.current_page params[:page].to_i.zero? ? 1 : params[:page].to_i
    json.page_size    params[:per].to_i.zero? ? l_f::DEFAULT_PER : params[:per]
    json.total_pages  @l_f.total_pages
    json.total        @l_f.count
  end

  json.l_f @lost_founds do |l_f|
    json.id l_f.id
    json.title l_f.title
    json.summary l_f.summary
    json.adddate l_f.addtime
  end
end
