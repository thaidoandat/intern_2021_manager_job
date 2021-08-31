class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  include OwnerHelper

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def handle_record_not_found
    flash[:danger] = t "controller.user_not_found"
    redirect_to root_path
  end

  protected

  def configure_permitted_parameters
    added_attrs = Account::ACCOUNT_PARAMS
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include? locale
    I18n.locale = check ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def find_job
    @job = Job.find_by id: params[:job_id]
    return if @job

    flash[:danger] = t "controller.job_not_found"
    redirect_to root_path
  end

  def redirect_register_information account
    redirect_to new_user_path if account.user?

    redirect_to new_company_path if account.company?
  end
end
