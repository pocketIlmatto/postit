module ApplicationHelper
  def format_url(url)
    url = /^http/i.match(url) ? url : "http://#{url}"
  end

  def generate_unique_username(name = '')
    begin
      username = "#{Faker::Internet.user_name(name)}_#{rand(100)}"
    end while User.find_by(username: username )
    username
  end

end
