module SessionHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  def current_user?(user)
    flash[:userUser] = user
    flash[:current_user_id] = user.id == current_user.id
    user.id == current_user.id
  end
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    flash[:current_user] = @current_user
  end
  def logged_in?
    !current_user.nil?
  end
end