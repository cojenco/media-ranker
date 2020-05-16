class HomepagesController < ApplicationController
  def index
    @works = Work.all
    @users = User.all
  end
end
