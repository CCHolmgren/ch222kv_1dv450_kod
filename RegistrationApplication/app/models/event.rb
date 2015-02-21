class Event < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user

  def serializable_hash(options={})
    options = {
        only: [:id, :name, :short_description, :description, :latitude, :longitude, :created_at],
        include: [:tag, :user =>
                          #Limit so that it doesn't nest forever
                          #Also, we only need a bit of info, if we want more, just go to the self link
                          { :only =>
                                [:username, :is_administrator], :include => [], :methods => [:self_link] }],
    }.update(options)
    super(options)
  end
end
