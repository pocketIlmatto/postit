class User < ActiveRecord::Base
	has_many :posts
	has_many :comments
	has_many :recent_posts, 
		-> { order('created_at desc').limit(2)},
		class_name: "Post"
  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3}
end