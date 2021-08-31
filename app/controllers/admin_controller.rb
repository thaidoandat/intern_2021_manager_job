class AdminController < ApplicationController
  layout "admin"

  before_action :check_role_admin, only: :index

  def index; end

  private

  def check_role_admin
    return if account_signed_in? && current_account.admin?

    redirect_to new_admin_session_path
    flash[:warning] = t "controller.no_permission"
  end
end
