class Event < ActiveRecord::Base
  include Rails.application.routes.url_helpers

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
  def self.limit_output(limit, offset)
    #Sort asc since that means start from id 1 and work upwards
    @events = Event.all.order("created_at ASC").offset(offset).limit(limit)

    if offset+limit >= Event.count
      next_link = nil
    elsif count < Event.count
      next_link = "#{Rails.configuration.baseurl}#{event_path(self)}?offset=#{offset+limit}&limit=#{limit}"
    else
      next_link = nil
    end
    #If the offset is larger than 0, there must be atleast 1 item before
    if offset > 0 && Event.count > 0
      #Do note that offset - limit can become negative, but since offset gets clamped, it doesn't really matter
      previous = "#{Rails.configuration.baseurl}#{event_path(self)}?offset=#{offset-limit}&limit=#{limit}"
    else
      previous = nil
    end
    return @events, next_link, previous, limit, offset
  end
  def self_link
    {:url => "#{Rails.configuration.baseurl}#{event_path(self)}"}
  end
end
