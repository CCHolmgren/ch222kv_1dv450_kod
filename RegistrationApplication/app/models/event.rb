class Event < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :user

  def serializable_hash(options={})
    options = {
        only: [:id, :name, :short_description, :description, :latitude, :longitude, :created_at],
        include: [:tags => {only: [:name]}, :user =>
                          #Limit so that it doesn't nest forever
                          #Also, we only need a bit of info, if we want more, just go to the self link
                          { :only =>
                                [:username, :is_administrator], :include => [], :methods => [:self_link] }],
        methods: [:self_link]
    }.update(options)
    super(options)
  end
  def self_link
    {:url => "http:localhost:3000/api/v1/events/#{self.id}"}
  end
end
