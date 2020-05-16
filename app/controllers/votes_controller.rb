class VotesController < ApplicationController
  
  def create
    work_upvote = params[:work_id]
    user_upvote = 1

    @vote = Vote.new(work_id: work_upvote, user_id: user_upvote)
    if @vote.save
      flash[:success] = "Successfully upvoted!"
      redirect_to work_path(work_upvote)
      return
    else
      flash.now[:error] = "Ooops! Failed to upvote."
      redirect_to work_path(work_upvote)
      return
    end

  end
end
