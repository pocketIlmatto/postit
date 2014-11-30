include ApplicationHelper
class User < ActiveRecord::Base
	has_many :posts, counter_cache: true
	has_many :comments, counter_cache: true
  has_many :votes
	has_many :recent_posts, 
		-> { order('created_at desc').limit(2)},
		class_name: "Post"
  has_secure_password validations: false
  has_many :authorizations
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3}


  def add_authorization(auth_hash)
    authorization = self.authorizations.build(uid: auth_hash[:uid], provider: auth_hash[:provider], auth_hash: auth_hash)     
  end

  def self.create_user_from_authorization(auth_hash)
    if auth_hash[:provider] == "facebook"
      user_name = auth_hash[:info][:first_name] + " " + auth_hash[:info][:last_name]
    elsif auth_hash[:provider] == "github"
      user_name = auth_hash[:info][:name]
    else
      user_name = Factory::Internet.user_name
    end
    @user = User.new(username: generate_unique_username(user_name), password: auth_hash[:uid])   
  end

  def has_authorization?(provider)
    self.authorizations.where(provider: provider).size == 0 ? false : true
  end
end