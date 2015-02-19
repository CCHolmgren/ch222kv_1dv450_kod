class EventsController < ApiController
  before_action :set_event
  respond_to :json
  def index
    respond_with Event.all
  end

  def show
    respond_with @event
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def destroy
  end
  private
    def set_event
      @event = Event.find(params[:id])
    end
end
