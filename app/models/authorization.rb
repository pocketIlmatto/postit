class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :user_id, presence: true
  validates_uniqueness_of :user_id, scope: :provider, message: "You have already associated your user account with this provider."
  validates_uniqueness_of :uid, scope: :provider, message: "This user has already been associated with an account on Postit."
end
