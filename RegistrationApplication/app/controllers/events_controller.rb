class EventsController < ApiController
  before_action :set_event, only: [:show, :update, :destroy]
  respond_to :json
  rescue_from ActionController::ParameterMissing, with: :raise_bad_format

  def index
    #This clamps the offset and limit values between 0 and Event.count-1, since there isnt a clamp function in ruby
    offset = [0, params[:offset].to_i, Event.count-1].sort[1]
    #This also clamps, between 1 and 5
    limit = [1, params[:limit].to_i, 5].sort[1]
    #Sort asc since that means start from id 1 and work upwards
    @events = Event.all.order("created_at ASC").offset(offset).limit(limit)

    count = @events.count

    #If the offset + limit selects higher items than there is, no next_link
    if offset+limit >= Event.count
      next_link = nil
    elsif count < Event.count
      next_link = "http://localhost:3000/api/v1/events/?offset=#{offset+limit}&limit=#{limit}"
    else
      next_link = nil
    end
    #If the offset is larger than 0, there must be atleast 1 item before
    if offset > 0 && Event.count > 0
      #Do note that offset - limit can become negative, but since offset gets clamped, it doesn't really matter
      previous = "http://localhost:3000/api/v1/events/?offset=#{offset-limit}&limit=#{limit}"
    else
      previous = nil
    end

    respond_with events: @events, total: Event.count, limit: limit, offset: offset, next: next_link, previous: previous
  end

  def show
    respond_with @event
  end

  def select_on_user
    @events = Event.where user: params[:user_id]
    respond_with events: @events
  end

  def new
    @event = Event.new
  end

  def edit
  end

  # Searches for events given the query
  # GET /search?q=
  # q is a space separated string which can contain quotes
  # the quoted substring is searched for verbatim

  # NOTE: This function requires that the database can handle ILIKE and ANY array, which postgresql does
  # SQLite does not
  def search
    #A bit complicated
    #This allows us to search for things like: "is this" real world
    #And it will behave like google search does
    #But only for quoted strings, no complicated stuff
    @events = Event.where("description ILIKE ANY (array[?])",
                          params[:q].
                              #Split on spaces, unless they are in quotes
                              split(/\s(?=(?:[^"]|"[^"]*")*$)/).
                              #Probably a better way to do this, create a string that is %thing% without the quotes
                              map { |thing| "%#{thing.tr('"', '')}%" })
    respond_with events: @events
  end

  def update
    if @event.update(event_params)
      respond_with { redirect_to @event, notice: 'Event was successfully updated.', status: :ok }
    else
      respond_with errors: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:tag_ids, :name, :short_description, :description)
  end

  def raise_bad_format
    respond_with ErrorMessage.new("This was a bad request", "Something went wrong with the request."), status: :bad_request
  end
end
class ErrorMessage
  def initialize(dev_mess, usr_mess)
    @developerMessage = dev_mess
    @userMessage = usr_mess
  end
end