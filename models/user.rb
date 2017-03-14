class User < ActiveRecord::Base
  validates :email, :password_digest, presence: true
  validates :deleted, inclusion: { in: [true, false] }
  has_secure_password
  has_many :albums
end
