class VotesController < ApplicationController

  before_action :require_login, only: [:create]     #in cases where no user logged in
  
  def create
    # in cases where user is login in session 
    upvote_work_id = params[:work_id]
    vote = Vote.new(work_id: upvote_work_id, user_id: @current_user.id)  #@current_user passed in by before_action
    
    if !vote.valid?                                 #invalid vote
      flash[:warning] = "A problem occurred: Could not upvote. User has already voted for this work"
      redirect_back(fallback_location: root_path)   #https://api.rubyonrails.org/classes/ActionController/Redirecting.html
      return
    end

    if vote.save
      flash[:success] = "Successfully upvoted!"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:warning] = "A probem occurred: Could not upvote due to system errors"
      redirect_back(fallback_location: root_path)
      return
    end
  end
end
