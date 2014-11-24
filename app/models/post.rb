class Post < ActiveRecord::Base
	before_save :format_url
	belongs_to :creator, class_name: "User", foreign_key: :user_id
	has_many :comments, counter_cache: true
	has_and_belongs_to_many :categories
	validates :user_id, presence: true
	validates :title, presence: true
	validates :url, presence: true

	private
		def format_url
			self.url = /^http/i.match(url) ? url : "http://#{self.url}"
		end
end