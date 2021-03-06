class ApiApplicationsController < ApplicationController
  require "securerandom"
  before_action :logged_in_user
  before_action :set_application, only: [:edit, :show, :update, :destroy]
  before_action :check_authorization, only: [:edit, :show, :update, :destroy]

  def create
    @api_application = current_user.api_applications.new(application_params)

    @api_application.client_key = SecureRandom.hex(n=32)
    @api_application.client_secret = SecureRandom.hex(n=32)

    respond_to do |format|
      if @api_application.save
        format.html { redirect_to @api_application, notice: 'Application was successfully created.' }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @api_applications = current_user.api_applications.paginate(page: params[:page])
    if current_user.is_administrator
      @api_applications = ApiApplication.all.paginate(page: params[:page])
    end
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
        format.html { redirect_to @api_application, notice: 'Api application was updated successfully' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @api_application.destroy
    respond_to do |format|
      format.html { redirect_to api_applications_url, notice: 'Api application was removed successfully' }
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
      redirect_to :back unless @api_application.user == current_user ||current_user.is_administrator?
    end
    def logged_in
      redirect_to login_path unless logged_in?
    end
end
