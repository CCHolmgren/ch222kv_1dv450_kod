class ApiApplicationsController < ApplicationController
  require "securerandom"
  include SessionHelper

  def create
    @api_application = ApiApplication.new(application_params)
    @api_application.client_key = SecureRandom.hex(n=64)
    @api_application.client_secret = SecureRandom.hex(n=64)
    @api_application.user = current_user

    respond_to do |format|
      if @api_application.save
        format.html { redirect_to @api_application, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @api_application }
      else
        format.html { render :new }
        format.json { render json: @api_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @api_applications = current_user.api_applications.all
  end

  def show
  end

  def new
    @api_application = ApiApplication.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def application_params
      params.require(:application).permit(:name, :description, :url)
    end
end
