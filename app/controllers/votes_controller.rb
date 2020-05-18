class VotesController < ApplicationController
  
  def create
    user = User.find_by(id: session[:user_id])
    # in cases where no user is in session
    if user.nil?
      flash[:warning] = "A problem occurred: You must log in to do that"
      redirect_back(fallback_location: root_path)   #https://api.rubyonrails.org/classes/ActionController/Redirecting.html
      return
    end

    # in cases where user is login in session
    upvote_work_id = params[:work_id]
    vote = Vote.new(work_id: upvote_work_id, user_id: user.id)
    # invalid vote 
    if !vote.valid?
      flash[:warning] = "A problem occurred: Could not upvote. User has already voted for this work"
      redirect_back(fallback_location: root_path)
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
