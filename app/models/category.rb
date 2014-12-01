include ApplicationHelper
class Category < ActiveRecord::Base
	has_and_belongs_to_many :posts
  validates :name, presence: true
  before_save :generate_slug

  def to_param
    slug
  end

  def generate_slug
    slug = create_slug(self.name) 
    i = 1
    while (Category.find_by(slug: slug))
      slug << i.to_s unless Category.find_by(slug: slug+i.to_s)
      i += 1
    end 
    self.slug = slug
  end

end