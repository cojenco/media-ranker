class UsersController < ApplicationController
  def index
    @users = User.all
  end

  
  def show
    @user = User.find_by(id: params[:id])

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
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
    return
  end
end
