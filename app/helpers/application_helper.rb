module ApplicationHelper
  def format_url(url)
    url = /^http/i.match(url) ? url : "http://#{url}"
  end

  def display_datetime(dt)
    dt.strftime("%m/%d/%Y %H:%M%p %Z")
  end

  def create_slug(fulltext)
    slug = fulltext.downcase.strip.gsub(/[^\w-]/, "-").gsub(/-+/, "-")
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0
      str = str.split('-').slice(0..-2).join('-')
    end
    str << "-#{count.to_s}"
  end

  def generate_unique_username(name = '')
    begin
      username = "#{Faker::Internet.user_name(name)}_#{rand(100)}"
    end while User.find_by(username: username )
    username
  end

end
