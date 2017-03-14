class Photo < ActiveRecord::Base
  validates :url, :album_id, presence: true
  validates :deleted, inclusion: { in: [true, false] }
  belongs_to :album
end
