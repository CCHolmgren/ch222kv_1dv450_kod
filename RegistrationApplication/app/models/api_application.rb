class ApiApplication < ActiveRecord::Base
  belongs_to :user
  validates :name, length: { minimum: 4, maximum: 50 }
  validates :description, length: { minimum: 10, maximum: 1000 }
end
