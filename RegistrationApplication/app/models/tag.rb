class Tag < ActiveRecord::Base
  has_and_belongs_to_many :events
  validates :name, presence: true, length: { maximum: 50, minimum: 4 }, uniqueness: { case_sensitive: false }

  def serializable_hash(options={})
    options = {
        only: [:name, :id],
        include: [events:  {only: [:id, :name, :short_description], include:[], methods: [:self_link]}],
        methods: [:links]
    }.update(options)
    super(options)
  end
  def links
    { rel: "self", href: "#{Rails.configuration.baseurl}#{tag_path(self)}"}
  end
end
