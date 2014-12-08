include ApplicationHelper
class Category < ActiveRecord::Base
	has_and_belongs_to_many :posts
  validates :name, presence: true, uniqueness: true
  before_save :generate_slug

  def to_param
    slug
  end

  def generate_slug
    slug = create_slug(self.name) 
    i = 2
    category = Category.find_by(slug: slug)
    while category && category != self
      slug = self.append_suffix(slug, i)
      category = Category.find_by(slug: slug)
      i += 1
    end 
    self.slug = slug
  end

end