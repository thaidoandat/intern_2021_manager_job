class SessionsController < ApplicationController
  before_action :find_account_by_email, only: %i(create)

  def new
    return unless logged_in?

    if current_owner
      redirect_back_or current_owner
    else
      redirect_register_information current_account
    end
  end

  def create
    if @account.authenticate params[:session][:password]
      login_account @account
      if current_owner
        redirect_back_or current_owner
      else
        redirect_register_information current_account
      end
    else
      flash[:danger] = t "sessions.login.failure"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def find_account_by_email
    @account = Account.find_by email: params[:session][:email]
    return if @account

    flash[:danger] = t "sessions.login.not_found"
    render :new
  end

  def remember? remember_me
    remember_me == "1"
  end

  def login_account account
    remember_me = remember? params[:session][:remember_me]
    log_in account
    flash[:success] = t "sessions.login.success"
    remember_me ? remember(account) : forget(account)
  end
end
