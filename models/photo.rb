class Photo < ActiveRecord::Base
  validates :url, :album_id, presence: true
  belongs_to :album
end
