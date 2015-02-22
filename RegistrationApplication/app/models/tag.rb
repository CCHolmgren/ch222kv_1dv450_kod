class Tag < ActiveRecord::Base
  has_and_belongs_to_many :events
  validates :name, presence: true, length: { maximum: 50, minimum: 4 }, uniqueness: { case_sensitive: false }

  def serializable_hash(options={})
    options = {
        only: [:name, :id],
        include: [:events => {only: [:id, :name, :short_description], include:[], methods: [:self_link]}],
        methods: [:self_link]
    }.update(options)
    super(options)
  end
  def self_link
    {:url => "http:localhost:3000/api/v1/tags/#{self.id}"}
  end
end
