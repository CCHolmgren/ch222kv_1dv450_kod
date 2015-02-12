class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  def index
    @tags = Tag.all
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
