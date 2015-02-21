class Tag < ActiveRecord::Base
  has_many :events
  validates :name, presence: true, length: {maximum: 50, minimum: 4}
  def serializable_hash(options={})
    options = {
        only: [:name, :id]
    }.update(options)
    super(options)
  end
end
