class Post < ActiveRecord::Base
	belongs_to :creator, class_name: "User", foreign_key: :user_id
	has_many :comments, counter_cache: true
	has_and_belongs_to_many :categories
	validates :user_id, presence: true
	validates :title, presence: true
	validates :url, presence: true
  has_many :votes, as: :voteable
	
  def total_votes
    upvotes - downvotes
  end

  def upvotes
    self.votes.where(vote: true).size
  end

  def downvotes
    self.votes.where(vote: false).size
  end
end