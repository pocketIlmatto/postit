class SessionsController < ApplicationController

  def new

  end

  def failure
    flash[:error] 
    flash[:error] = "Something went wrong during authentication.  Please try again!"
    if logged_in?
      redirect_to user_path current_user
    else
      render :new
    end

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

  def create_with_auth
    auth_hash = request.env['omniauth.auth']
    if logged_in?
      add_user_authorization(auth_hash)
    else
      @authorization = Authorization.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])
      if @authorization.nil?
        @user = User.create_user_from_authorization(auth_hash)
        if @user.save
          session[:user_id] = @user.id
          add_user_authorization(auth_hash)
        else
          flash[:error] = "Something went wrong during authentication.  Please try again!"
          render :new
        end
      else
        session[:user_id] = @authorization.user_id
        redirect_to user_path current_user
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out!"
    redirect_to root_path
  end

  private

  def add_user_authorization(auth_hash)
    @authorization = current_user.add_authorization(auth_hash)
    if @authorization.save
      flash[:notice] = "You can now login using #{auth_hash[:provider].capitalize}!"
      redirect_to user_path current_user
    else
      flash[:error] = "Something went wrong during authentication.  Please try again!"
      if logged_in?
        redirect_to user_path current_user
      else
        render :new
      end
    end
  end

end

    #binding.pry
    # @authorization = Authorization.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])
    # #authorization already exists in our database
    # if !@authorization.nil?
    #   if logged_in? 
    #     if @authorization.user == current_user
    #       redirect_to user_path current_user
    #     else
    #       flash[:error] = "This #{@authorization.provider.capitalize} account is already associated with a different user account."
    #       redirect_to user_path current_user
    #     end
    #   else
    #     session[:user_id]  = @authorization.user.id
    #     redirect_to user_path current_user
    #   end
    # else
    #   #authorization does not exist
    #   if logged_in?
    #     #if logged in, build association for this user
    #     @authorization = current_user.authorizations.build(uid: auth_hash[:uid], provider: auth_hash[:provider])
    #     if @authorization.save
    #       flash[:notice] = "You can login using #{auth_hash[:provider].capitalize}!"
    #       redirect_to user_path current_user
    #     else
    #       flash[:error] = "Something went wrong during authentication.  Please try again!"
    #       render :new
    #     end
    #   else
    #     #otherwise create a new user, associate with the authorization and log-in
    #     @user = User.new(username: generate_unique_username, password: auth_hash[:uid])
    #     if @user.save
    #       @authorization = @user.authorizations.build(uid: auth_hash[:uid], provider: auth_hash[:provider])
    #       if @authorization.save
    #         session[:user_id] = @user.id
    #         flash[:notice] = "You may now login with using #{auth_hash[:provider].capitalize}!  Your auto-generated username is #{@user.username} - you may change this on your Edit profile page."
    #         redirect_to edit_user_path current_user
    #       else
    #         flash[:error] = "Something went wrong during authentication.  Please try again!"
    #         render :new
    #       end
    #     else
    #       flash[:error] = "Something went wrong during authentication.  Please try again!"
    #       render :new
    #     end
    #   end
    # end