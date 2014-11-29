class SessionsController < ApplicationController

  def new

  end

  def failure

  end

  def connect

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

  #TODO refactor some of this logic onto the models
  def create_with_auth
    auth_hash = request.env['omniauth.auth']
    #binding.pry
    @authorization = Authorization.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])
    #authorization already exists in our database
    if !@authorization.nil?
      if logged_in? 
        if @authorization.user == current_user
          redirect_to user_path current_user
        else
          flash[:error] = "This #{@authorization.provider.capitalize} account is already associated with a different user account."
          redirect_to user_path current_user
        end
      else
        session[:user_id]  = @authorization.user.id
        redirect_to user_path current_user
      end
    else
      #authorization does not exist
      if logged_in?
        #if logged in, build association for this user
        @authorization = current_user.authorizations.build(uid: auth_hash[:uid], provider: auth_hash[:provider])
        if @authorization.save
          flash[:notice] = "You can login using #{auth_hash[:provider].capitalize}!"
          redirect_to user_path current_user
        else
          flash[:error] = "Something went wrong during authentication.  Please try again!"
          render :connect
        end
      else
        #otherwise create a new user, associate with the authorization and log-in
        @user = User.new(username: generate_unique_username, password: auth_hash[:uid])
        if @user.save
          @authorization = @user.authorizations.build(uid: auth_hash[:uid], provider: auth_hash[:provider])
          if @authorization.save
            session[:user_id] = @user.id
            flash[:notice] = "You may now login with using #{auth_hash[:provider].capitalize}!  Your auto-generated username is #{@user.username} - you may change this on your Edit profile page."
            redirect_to edit_user_path current_user
          else
            flash[:error] = "Something went wrong during authentication.  Please try again!"
            render :new
          end
        else
          flash[:error] = "Something went wrong during authentication.  Please try again!"
          render :new
        end
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out!"
    redirect_to root_path
  end
end