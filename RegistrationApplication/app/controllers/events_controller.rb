class EventsController < ApiController
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :offset_params, only: [:index, :proximity]
  respond_to :json
  rescue_from ActionController::ParameterMissing, with: :raise_bad_format

  def index
    @events, next_link, previous, limit, offset = Event.limit_output(@limit, @offset)

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

  def proximity
    @events = Event.all.where(latitude: (params[:min_lat].to_i)..(params[:max_lat].to_i), longitude: (params[:min_lng].to_i)..(params[:max_lng].to_i)).
        order("created_at ASC").
        offset(@offset).
        limit(@limit)

    respond_with events: @events, total: @events.count, limit: @limit, offset: @offset
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