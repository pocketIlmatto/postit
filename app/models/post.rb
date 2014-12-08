include ApplicationHelper
class Post < ActiveRecord::Base
  include Voteable

  belongs_to :creator, class_name: "User", foreign_key: :user_id
	has_many :comments, counter_cache: true
	has_and_belongs_to_many :categories
	validates :user_id, presence: true
	validates :title, presence: true
	validates :url, presence: true
  before_save :generate_slug
  	
  def to_param
    slug
  end

  def generate_slug
    slug = create_slug(self.title) 
    i = 2
    post = Post.find_by(slug: slug)
    while post && post != self
      slug = self.append_suffix(slug, i)
      post = Post.find_by(slug: slug)
      i += 1
    end 
    self.slug = slug
  end

end