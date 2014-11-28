class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      flash[:notice] = "Welcome back #{user.username}!"
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = "Your username and/or password is invalid."
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out!"
    redirect_to root_path
  end
end