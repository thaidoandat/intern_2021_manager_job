class JobsController < ApplicationController
  before_action :log_in_require, :load_company, except: %i(index show)
  before_action :load_job, except: %i(index new create)
  before_action :correct_company, only: %i(edit update destroy)

  def index
    @jobs = if params[:commit]
              Job.search_by(search_params).page(params[:page])
                 .per Settings.jobs.max_items_per_page
            else
              Job.newest.includes(:company).page(params[:page])
                 .per Settings.jobs.max_items_per_page
            end
  end

  def new
    @job = @company.jobs.build
    @categories = Category.all
  end

  def create
    @job = @company.jobs.build job_params
    if @job.save && @job.save_job_categories(params[:job][:job_categories])
      flash[:success] = t "jobs.create.success"
      redirect_to @job
    else
      flash[:danger] = t "jobs.create.failure"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @job.update job_params
      flash[:success] = t "jobs.update.success"
      redirect_to @job
    else
      flash[:danger] = t "jobs.update.failure"
      render :edit
    end
  end

  def destroy
    if @job.destroy
      flash[:success] = t "jobs.destroy.success"
    else
      flash[:failure] = t "jobs.destroy.failure"
    end
    redirect_to @company
  end

  private

  def load_company
    if current_account.company?
      @company = current_account.company
      return if @company

      redirect_to new_company_path
    else
      redirect_to root_path
    end
  end

  def load_job
    @job = Job.find_by id: params[:id]
    return if @job

    flash[:danger] = t "controller.job_not_found"
    redirect_to root_path
  end

  def correct_company
    redirect_to @job unless @job.company == current_account.company
  end

  def job_params
    params.require(:job).permit Job::JOB_PARAMS
  end

  def search_params
    params[:companies] = params[:companies].keys if params.key? :companies
    params[:categories] = params[:categories].keys if params.key? :categories
    params.permit [:salary_id, companies: [], categories: []]
  end
end
