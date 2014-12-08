class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :content_creator?, :content_creator_or_admin?, :require_admin, :current_timezone

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def content_creator?(creator_id)
    logged_in? && creator_id == current_user.id
  end

  def logged_in?
    !!current_user
  end

  def content_creator_or_admin?(creator_id)
    logged_in? && (content_creator?(creator_id) || current_user.is_admin?)
  end

  def require_user
    if !logged_in?
      flash[:error] = "You must be logged in to perform that action!"
      redirect_to login_path
    end
  end

  def current_timezone
    if logged_in? && current_user.timezone
      current_user.timezone
    else
      config.time_zone 
    end
  end

  def require_logged_in_object_creator(creator_id)
    if !content_creator?(creator_id) 
      flash[:error] = "You do not have enough rights to perform that action!"
      redirect_to root_path
    end
  end

  def require_creator_or_admin(creator_id)
    unless current_user.is_admin?
      require_logged_in_object_creator(creator_id)
    end
  end

  def require_admin
    if !logged_in? || !current_user.is_admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to root_path
    end
  end

end
