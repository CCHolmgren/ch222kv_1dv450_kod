class SessionsController < ApplicationController
  def login
    if request.post?
      user = User.find_by(username: params[:session][:username])
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to users_url
      end
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
end
