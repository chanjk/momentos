class Album < ActiveRecord::Base
  validates :name, :user_id, presence: true
  validates :deleted, inclusion: { in: [true, false] }
  belongs_to :user
  has_many :photos
end
