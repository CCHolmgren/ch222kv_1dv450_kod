class User < ActiveRecord::Base
  require "securerandom"
  attr_accessor :remember_token
  has_many :api_applications
  has_many :events
  before_save { self.email = email.downcase }
  validates :username, presence: true, length: { maximum: 50, minimum: 4 }, :case_sensitive => false
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :email, format: { with: /@/ }
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    BCrypt::Password.create(string, cost: cost)
  end
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  def forget
    update_attribute(:remember_digest, nil)
  end
  def serializable_hash(options={})
    options = {
        only: [:username, :is_administrator],
        #The empty include makes it so that the includes in the serialize doesn't get carried over
        #We also do not really want to provide any more information than necessary, so just
        #provide some information, not all
        include: [:events => {only: [:name, :id, :short_description], include: []}],
        methods: [:self_link]
    }.update(options)
    super(options)
  end
  def self_link
    { :url => "#{Rails.configuration.baseurl}#{user_path(self)}"}
  end
end
