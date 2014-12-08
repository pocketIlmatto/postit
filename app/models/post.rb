include ApplicationHelper
class Post < ActiveRecord::Base
	belongs_to :creator, class_name: "User", foreign_key: :user_id
	has_many :comments, counter_cache: true
	has_and_belongs_to_many :categories
	validates :user_id, presence: true
	validates :title, presence: true
	validates :url, presence: true
  has_many :votes, as: :voteable
  before_save :generate_slug
	
  def total_votes
    upvotes - downvotes
  end

  def upvotes
    self.votes.where(vote: true).size
  end

  def downvotes
    self.votes.where(vote: false).size
  end

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