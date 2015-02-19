class Tag < ActiveRecord::Base
  validates :name, presence: true, length: {maximum: 50, minimum: 4}
  def serializable_hash(options={})
    options = {
        only: [:name, :created_at, :id]
    }.update(options)
    super(options)
  end
end
