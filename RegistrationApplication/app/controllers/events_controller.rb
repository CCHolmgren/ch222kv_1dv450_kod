class EventsController < ApiController
  include ApiHelper
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :offset_params, only: [:index, :proximity, :search]
  respond_to :json
  rescue_from ActionController::ParameterMissing, with: :raise_bad_format

  def index
    @events, next_link, previous = limit_output(Event.all.order("created_at ASC"), @limit, @offset, "#{events_path}",Event)

    respond_with events: @events,
                 total: Event.count,
                 limit: @limit,
                 offset: @offset,
                 next: next_link,
                 previous: previous,
                 links: [{rel: "events", href: "#{Rails.configuration.baseurl}#{events_path}"},
                         {rel: "search", href:"#{Rails.configuration.baseurl}#{events_search_path}"},
                         {rel: "location", href:"#{Rails.configuration.baseurl}#{events_location_path}"}]
  end

  def show
    unless @event.nil?
      respond_with @event, status: :ok
    else
      @error = {status: 400, message: "invalid id"}
      respond_with @error, status: :not_found
    end

  end

  def select_on_user
    @events = Event.where user: params[:user_id]
    respond_with events: @events
  rescue RangeError
    render json: {message: "Your provided id is out of range, try a smaller one"}, status: :bad_request
  end

  def new
    @event = Event.new
  end
  def create
    if @user.nil?
      render json: {message: "You are not authorized to create a new event"}, status: :unauthorized
      return
    end
    @event = Event.new(event_params)
    if @event.save
      respond_with { redirect_to :events }
    else
      render :new
    end
  end
  def edit
  end

  def proximity
    #Clamping
    #Latitude can be at most -85 to 85 degrees, or maybe more, but google maps only allow that range,
    #give or take a few degree minutes/seconds
    min_lat = [-85,params[:min_lat].to_i,85].sort[1]
    max_lat = [-85,params[:max_lat].to_i,85].sort[1]

    #Longitude can be at most -180 to 180 degrees
    min_lng = [-180,params[:min_lng].to_i,180].sort[1]
    max_lng = [-180,params[:max_lng].to_i, 180].sort[1]

    _events = Event.all.where(latitude: min_lat..max_lat, longitude: min_lng..max_lng).
        order("created_at ASC")
    @events, next_link, previous = limit_output(_events, @limit, @offset, "#{events_location_path}", Event)

    respond_with events: @events,
                 total: @events.count,
                 limit: @limit,
                 offset: @offset,
                 min_lat: min_lat,
                 max_lat: max_lat,
                 min_lng: min_lng,
                 max_lng: max_lng,
                 next_link: next_link,
                 previous: previous,
                 links: [{rel:"location", href:"#{Rails.configuration.baseurl}#{events_location_path}"}]
  end

  # Searches for events given the query
  # GET /search?q=
  # q is a space separated string which can contain quotes
  # the quoted substring is searched for verbatim

  # NOTE: This function requires that the database can handle ILIKE and ANY array, which postgresql does
  # SQLite does not
  def search
    query = params[:q] || ""
    #A bit complicated
    #This allows us to search for things like: "is this" real world
    #And it will behave like google search does
    #But only for quoted strings, no complicated stuff
    @events, next_link, previous = limit_output(Event.where("description ILIKE ANY (array[?])",
                          query.
                              #Split on spaces, unless they are in quotes
                              split(/\s(?=(?:[^"]|"[^"]*")*$)/).
                              #Probably a better way to do this, create a string that is %thing% without the quotes
                              map { |thing| "%#{thing.tr('"', '')}%" }), @limit, @offset,"#{events_search_path}")
    respond_with events: @events,
                 query: query,
                 limit: @limit,
                 offset: @offset,
                 next_link: next_link,
                 previous: previous,
                 links: [{rel: "search", href:"#{Rails.configuration.baseurl}#{events_search_path}"}]
  end

  def update
    if @event.update(event_params)
      respond_with { redirect_to @event, notice: 'Event was successfully updated.', status: :ok }
    else
      respond_with errors: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    p @user
    if @event.user == @user or @user.is_administrator
      @event.destroy
      render json: {message: "Removed event"}, status: :ok
      return
    else
      render json: {message: "You are not authorized to remove that event"}, status: :unauthorized
    end
  end

  private
    def set_event
      @event = Event.find_by_id(params[:id])
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