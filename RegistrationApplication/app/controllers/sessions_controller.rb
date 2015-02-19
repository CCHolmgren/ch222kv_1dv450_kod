class SessionsController < ApplicationController
  before_action :check_logged_in, only: [:login]
  before_action :check_logout, only: [:logout]
  def login
    if request.post?
      user = User.where("lower(username) = ?", params[:session][:username].downcase).first
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to users_url
      end
      flash.now[:error] = "That combination did not seem to work."
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
