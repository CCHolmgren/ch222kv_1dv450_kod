class Token < ActiveRecord::Base
  require "securerandom"
  belongs_to :user
  before_save :set_auth_token

  def set_auth_token
    return if value.present?
    update_attribute(:value, generate_auth_token)
  end
  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/, '')
  end
end
