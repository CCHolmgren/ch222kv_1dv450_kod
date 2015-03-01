module ApiHelper
  include Rails.application.routes.url_helpers
  def limit_output(object, limit, offset, path, base)
    #Sort asc since that means start from id 1 and work upwards
    objects = object.offset(offset).limit(limit)

    if offset+limit >= base.count
      next_link = nil
    elsif object.count < base.count
      next_link = "#{Rails.configuration.baseurl}#{path}?offset=#{offset+limit}&limit=#{limit}"
    else
      next_link = nil
    end
    #If the offset is larger than 0, there must be atleast 1 item before
    if offset > 0 && base.count > 0
      #Do note that offset - limit can become negative, but since offset gets clamped, it doesn't really matter
      previous = "#{Rails.configuration.baseurl}#{path}?offset=#{offset-limit}&limit=#{limit}"
    else
      previous = nil
    end

    [objects, next_link, previous]
  end
end
