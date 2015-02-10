class User < ActiveRecord::Base
  has_one :api_application
  before_save { self.email = email.downcase }
  validates :username, presence: true, length: { maximum: 50, minimum: 4 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :email, format: { with: /@/ }
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_secure_password
end
