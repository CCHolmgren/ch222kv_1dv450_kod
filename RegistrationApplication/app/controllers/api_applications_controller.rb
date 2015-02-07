class ApiApplicationsController < ApplicationController
  require "securerandom"
  include SessionHelper
  before_action :set_application, only: [:edit, :show, :update, :destroy]
  before_action :check_authorization, only: [:edit, :show, :update, :destroy]
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
    respond_to do |format|
      if @api_application.update(application_params)
        format.html { redirect_to @api_application, notice: 'Api application was updated successfully'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @api_application.destroy
    respond_to do |format|
      format.html { redirect_to api_applications_url, notice: 'Api application was removed successfully'}
    end
  end

  private
    def application_params
      params.require(:api_application).permit(:name, :description, :url)
    end
    def set_application
      @api_application = ApiApplication.find(params[:id])
    end
    def check_authorization
      if @api_application.user != current_user
        redirect_to :root
      end
    end
end
