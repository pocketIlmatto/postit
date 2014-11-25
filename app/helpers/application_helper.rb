module ApplicationHelper
  def format_url(url)
    url = /^http/i.match(url) ? url : "http://#{url}"
  end
end
