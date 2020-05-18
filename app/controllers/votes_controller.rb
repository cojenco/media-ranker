class VotesController < ApplicationController
  
  def create
    user = User.find_by(id: session[:user_id])
    if user.nil?
      flash[:warning] = "A problem occurred: You must log in to do that"
      redirect_back(fallback_location: root_path)   #https://api.rubyonrails.org/classes/ActionController/Redirecting.html
      return
    end

    upvote_work_id = params[:work_id].to_i
    vote = Vote.new(work_id: upvote_work_id, user_id: user.id)
    if vote.save
      flash[:success] = "Successfully upvoted!"
      redirect_to work_path(upvote_work_id)
      return
    else
      flash[:error] = "Ooops! Failed to upvote."
      redirect_to work_path(upvote_work_id)
      return
    end
  end
end
