class WorksController < ApplicationController
  def index
    @works = Work.all
  end

  
  def show
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
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
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    end
  end


  def update
    @work = Work.find_by(id: params[:id])
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
    work = Work.find_by(id: params[:id])
    if work.nil?
      head :not_found
      return
    else
      work.destroy
      flash[:success] = "Successfully destroyed #{work.category} #{work.id}"
      redirect_to works_path
    end
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
