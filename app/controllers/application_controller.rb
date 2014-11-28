class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :content_owner

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def content_owner(owner_id)
    logged_in? && owner_id == @current_user.id
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = "You must be logged in to perform that action!"
      redirect_to login_path
    end
  end

  def require_logged_in_object_owner(owner_id)
    if !content_owner(owner_id)
      flash[:error] = "You do not have enough rights to perform that action!"
      redirect_to login_path
    end
  end

end
