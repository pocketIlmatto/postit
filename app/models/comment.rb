class Comment < ActiveRecord::Base
	belongs_to :creator, class_name: "User", foreign_key: :user_id
  belongs_to :post
  validates  :body, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true
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