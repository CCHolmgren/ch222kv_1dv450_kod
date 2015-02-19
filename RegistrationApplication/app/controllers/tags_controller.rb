class TagsController < ApiController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  respond_to :json
  def index
    respond_with Tag.all #@tags = Tag.all
  end

  def show

  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to :tags
    else
      render :new
    end
  end

  def update
  end

  def destroy
  end

  private
    def set_tag
      @tag = Tag.find(params[:id])
    end
    def tag_params
      params.require(:tag).permit(:name)
    end
end
