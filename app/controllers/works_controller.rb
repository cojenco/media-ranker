class WorksController < ApplicationController
  
  before_action :find_work, only: [:show, :edit, :update, :destroy]

  def index
    @works = Work.all
  end


  def show
    if @work.nil?
      flash[:warning] = "Media ID #{params[:id]} is no longer available"
      redirect_to root_path
      return
    end
  end


  def new
    @work = Work.new
  end


  def create
    @work = Work.new(work_params)

    if @work.save
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
      return
    else
      render :new, status: :bad_request
      return
    end
  end


  def edit
    if @work.nil?
      head :not_found
      return
    end
  end


  def update
    return head :not_found if @work.nil?

    if @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
      return
    else
      flash.now[:error] = "Ooops! #{@work.category} #{@work.id} was not updated."
      render :edit, status: :bad_request
      return
    end
  end
  

  def destroy
    if @work.nil?
      head :not_found
      return
    else
      @work.destroy
      flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"
      redirect_to works_path
    end
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end

  
  def find_work
    @work = Work.find_by(id: params[:id])
  end
end
