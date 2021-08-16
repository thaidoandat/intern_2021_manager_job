class AdminSessionsController < ApplicationController
  before_action :find_account_by_email, only: :create

  layout "admin_sessions"

  def new; end

  def create
    if @account.authenticate params[:session][:password]
      log_in @account
      redirect_to admin_index_path
    else
      flash.now[:danger] = t "sessions.login.failure"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to new_admin_session_path
  end

  private

  def find_account_by_email
    @account = Account.admin.find_by email: params[:session][:email].downcase
    return if @account

    render :new
    flash[:danger] = t "sessions.login.not_found"
  end
end
