class Tag < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  has_and_belongs_to_many :events
  validates :name, presence: true, length: { maximum: 50, minimum: 4 }, uniqueness: { case_sensitive: false }

  def serializable_hash(options={})
    options = {
        only: [:name, :id],
        include: {events:  {only: [:id, :name, :short_description], include:[user: {include:[]}], methods: [:self_link]}},
        methods: [:links]
    }.update(options)
    super(options)
  end
  def links
    { rel: "self", href: "#{id}"}
  end
end
