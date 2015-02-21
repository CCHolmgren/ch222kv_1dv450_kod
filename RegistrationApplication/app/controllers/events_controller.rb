class EventsController < ApiController
  before_action :set_event, only: [:show, :update, :destroy]
  respond_to :json

  def index
    offset = (params[:offset] or 0)
    limit = (params[:limit] or 5)
    @events = Event.all.order("created_at DESC")
    respond_with events: @events, total: Event.count, limit: limit, offset: offset, next: nil, previous: nil
  end

  def show
    respond_with @event
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
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
end
