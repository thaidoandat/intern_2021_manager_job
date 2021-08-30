class CompaniesController < ApplicationController
  before_action :check_role_company, only: %i(new create edit update)
  before_action :load_company, except: %i(new create)

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
    @search = Job.ransack params[:q]
    @jobs = @search.result.newest.page(params[:page])
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

  def load_company
    @company = Company.find_by id: params[:id]
    return if @company

    flash[:warning] = t "controller.company_not_found"
    redirect_to root_path
  end
end
