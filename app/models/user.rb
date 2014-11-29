class User < ActiveRecord::Base
	has_many :posts, counter_cache: true
	has_many :comments, counter_cache: true
  has_many :votes
	has_many :recent_posts, 
		-> { order('created_at desc').limit(2)},
		class_name: "Post"
  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 3}


end