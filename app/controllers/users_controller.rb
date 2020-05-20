class UsersController < ApplicationController

  before_action :require_login, only: [:logout]
  before_action :find_user, only: [:show]

  def index
    @users = User.all
  end

  
  def show
    if @user.nil?
      head :not_found
      return
    end
  end


  def login_form
    @user = User.new
  end


  def login
    user = User.find_by(username: params[:user][:username])

    if user       #existing user
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as existing user #{user.username}"
    else          #new user
      user = User.create(username: params[:user][:username])
      session[:user_id] = user.id
      flash[:success] = "Successfully created new user #{user.username} with ID #{user.id}"
    end

    redirect_to root_path
    return
  end


  def logout
    # in cases where user is in session
    user = User.find_by(id: session[:user_id])
    if user
      session[:user_id] = nil
      flash[:success] = "Successfully logged out"
      redirect_to root_path
      return
    else
      session[:user_id] = nil
      flash[:warning] = "A problem occured: Unknown user"
      redirect_to root_path
      return
    end
  end

  private

  #would come handy in the future when more routes and controller actions are created
  def find_user   
    @user = User.find_by(id: params[:id])
  end
end
