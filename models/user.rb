class User < ActiveRecord::Base
  validates :email, :password_digest, presence: true
  has_secure_password
  has_many :albums

  def username
    full_name || email
  end
end
