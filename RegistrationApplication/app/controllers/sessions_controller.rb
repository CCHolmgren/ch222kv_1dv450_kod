class SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_logged_in, only: [:login]
  before_action :check_logout, only: [:logout]
  respond_to :json, :xml
  def login
    if request.post?
      p params[:session]
      user = User.where("lower(username) = ?", params[:username]).first
      if user && user.authenticate(params[:password])
        #log_in user
        #params[:remember_me] == '1' ? remember(user) : forget(user)
        @token = Token.create(user: user, expiry: 15.hours.from_now)
        render json: { token: @token, user: user } and return
      end
      flash.now[:error] = "That combination did not seem to work."
      render json: {message: "That combination did not seem to work."}, status: :bad_request and return
    end
  end

  def logout
    if request.post?
      log_out if logged_in?
      respond_to do |format|
        format.html { redirect_to :root, notice: "Logged out" }
      end
    end
  end
  def index
  end

  private
    def check_logged_in
      redirect_to :root unless !logged_in?
    end
    def check_logout
      redirect_to :root unless logged_in?
    end
end
