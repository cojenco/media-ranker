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
    @user = User.find_by(user_params)

    if @user.nil?       
      @user = User.new(user_params)
      if @user.save                  #new user and valid
        flash[:success] = "Successfully created new user #{@user.username} with ID #{@user.id}"
      else                           #new user with invalid username (blank username)
        render :login_form, status: :bad_request
        return
      end
    else                             #existing user
      flash[:success] = "Successfully logged in as existing user #{@user.username}"
    end

    session[:user_id] = @user.id
    redirect_to root_path
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

  def user_params
    return params.require(:user).permit(:username)
  end

  #would come handy in the future when more routes and controller actions are created
  def find_user   
    @user = User.find_by(id: params[:id])
  end
end
