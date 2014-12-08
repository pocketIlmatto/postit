include ApplicationHelper
class Post < ActiveRecord::Base
  
  include Voteable
  include Sluggable
  belongs_to :creator, class_name: "User", foreign_key: :user_id
	has_many :comments, counter_cache: true
	has_and_belongs_to_many :categories
	validates :user_id, presence: true
	validates :title, presence: true
	validates :url, presence: true
  sluggable_column :title
  	
end