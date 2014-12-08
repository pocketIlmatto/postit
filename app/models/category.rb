include ApplicationHelper
class Category < ActiveRecord::Base
	
  include Sluggable
  has_and_belongs_to_many :posts
  validates :name, presence: true, uniqueness: true
  sluggable_column :name
  
end