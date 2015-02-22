class TagsController < ApiController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  respond_to :json

  def index
    respond_with Tag.all #@tags = Tag.all
  end

  def show
    respond_with @tag
  end

  def new
    @tag = Tag.new
  end

  def edit
  end
  def select_on_tag
    @events = Tag.find(params[:id]).events
    #Is there some other way to do this to not create a nesting of
    #event -> tags -> events?
    respond_with @events.to_json(include: [:tags => {include: []}])
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      respond_with { redirect_to :tags }
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.destroy
    respond_with { redirect_to :tags }
  end

  private
  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
