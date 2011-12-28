class AuthenticationsController < ApplicationController
  
  def handle_unverified_request
    true
  end
  
  before_filter :require_user, :only => [:destroy]
  
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    # render :text => auth.to_yaml
    @auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    if current_user
      
      # Add an auth to existing logged in user
      current_user.authentications.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      flash[:notice] = "Successfully added #{omniauth['provider']} authentication"
      redirect_to edit_user_path(current_user)

    elsif @auth
      
      # User is present. Login the user with his social account
      UserSession.create(@auth.user, true)
      redirect_to root_url 
      flash[:notice] = "Welcome back #{omniauth['provider']} user"

    else
      
      # This is a new user. Create an account and log him in
      # puts "hash: "+omniauth.to_yaml.log_red
      # TODO: Display new user form if username taken - errors out at the moment
      @new_auth = Authentication.create_from_hash(omniauth, current_user) #Create a new user
      flash[:notice] = "Welcome #{omniauth['provider']} user. Your account has been created."
      UserSession.create(@new_auth.user, true) # Log the authorizing user in.
      redirect_to root_url
      
    end
  end
  
  def failure
    flash[:notice] = "Sorry, authentication failed."
    redirect_to authentications_url
  end
  
  def destroy
    # TODO: User needs to be deleted if all auths are destroyed and no local password set
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
