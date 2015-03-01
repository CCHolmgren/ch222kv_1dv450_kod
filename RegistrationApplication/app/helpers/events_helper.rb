module EventsHelper

  include Rails.application.routes.url_helpers
  def limit_output(events, limit, offset, path)
    #Sort asc since that means start from id 1 and work upwards
    events = events.offset(offset).limit(limit)

    if offset+limit >= Event.count
      next_link = nil
    elsif events.count < Event.count
      next_link = "#{Rails.configuration.baseurl}#{path}?offset=#{offset+limit}&limit=#{limit}"
    else
      next_link = nil
    end
    #If the offset is larger than 0, there must be atleast 1 item before
    if offset > 0 && Event.count > 0
      #Do note that offset - limit can become negative, but since offset gets clamped, it doesn't really matter
      previous = "#{Rails.configuration.baseurl}#{path}?offset=#{offset-limit}&limit=#{limit}"
    else
      previous = nil
    end

    return events, next_link, previous
  end
end
