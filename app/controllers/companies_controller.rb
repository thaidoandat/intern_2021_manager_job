class CompaniesController < ApplicationController
  before_action :check_role_company, only: %i(new create)
  before_action :load_company, except: %i(new create)
  before_action :correct_company, only: %i(edit update)

  def new
    @company = current_account.build_company
  end

  def create
    @company = current_account.build_company company_params
    return render :new unless @company.save

    flash[:success] = t "controller.provide_info_success"
    redirect_to root_path
  end

  def show
    @jobs = @company.jobs.by_name(params[:name])
                    .newest.page(params[:page])
                    .per Settings.companies.page.max
  end

  def edit; end

  def update
    if @company.update company_update_params
      flash[:success] = t "controller.profile_updated"
      redirect_to @company
    else
      flash[:danger] = t "controller.profile_update_failed"
      render :edit
    end
  end

  private
  def check_role_company
    return if current_account.company?

    flash[:warning] = t "controller.no_permission"
    redirect_to root_path
  end

  def company_params
    params.require(:company).permit Company::COMPANY_PARAMS
  end

  def company_update_params
    params.require(:company).permit Company::UPDATE_PARAMS
  end

  def correct_company
    return if current_owner == @company

    redirect_to root_path
    flash[:warning] = t "controller.no_permission"
  end

  def load_company
    @company = Company.find_by id: params[:id]
    return if @company

    flash[:warning] = t "controller.company_not_found"
    redirect_to root_path
  end
end
