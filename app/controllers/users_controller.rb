class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action only: [:edit, :update, :destroy] do
    require_logged_in_object_owner(@user.id)
  end

  def show

  end

  def new
    @user = User.new
  end

  def create
    #TODO handle the pw matching on the front-end
    @user = User.new(user_params)
    # if params[:password] != params[:password_validation]
    #   flash[:error] = "Your passwords do not match"
    #   render :new and return
    # end
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username}!"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    @user.update(user_params)
    if @user.save
      flash[:notice] = "Your profile has been updated."
      redirect_to user_path @user
    else
      render :edit
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_validation)
  end
end