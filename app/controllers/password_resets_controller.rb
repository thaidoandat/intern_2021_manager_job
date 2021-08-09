class PasswordResetsController < ApplicationController
  before_action :get_account, :valid_account, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @account = Account.find_by email: params[:password_reset][:email].downcase
    if @account
      @account.create_reset_digest
      @account.send_password_reset_email
      flash[:info] = t "password_resets.create.reset_password_email"
      redirect_to root_path
    else
      flash.now[:danger] = t "password_resets.create.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:account][:password].empty?
      @account.errors.add :password, t("password_resets.update.no_empty")
      render :edit
    elsif @account.update account_params
      log_in @account
      flash[:success] = t "password_resets.update.reset_password_success"
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def get_account
    @account = Account.find_by email: params[:email]
    return if @account

    flash[:danger] = t "sessions.login.not_found"
    redirect_to root_path
  end

  def valid_account
    return if @account.activated? &&
              @account.authenticated?(:reset, params[:id])

    flash[:danger] = t "password_resets.invalid"
    redirect_to root_path
  end

  def check_expiration
    return unless @account.password_reset_expired?

    flash[:danger] = t "password_resets.password_reset_expired"
    redirect_to new_password_reset_url
  end

  def account_params
    params.require(:account).permit Account::PASSWORD_PARAMS
  end
end
