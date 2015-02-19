class TagsController < ApiController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  respond_to :json
  def index
    respond_with Tag.all #@tags = Tag.all
  end

  def show

  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
    def set_tag
      @tag = Tag.find(params[:id])
    end
end
