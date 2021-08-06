class AccountsController < ApplicationController
  def new
    redirect_to root_path if logged_in?

    @account = Account.new
  end

  def create
    @account = Account.new account_params

    if @account.save
      flash[:success] = t "accounts.create.success"
      log_in @account
      redirect_register_information @account
    else
      flash[:danger] = t "accounts.create.failure"
      render :new
    end
  end

  private

  def account_params
    params.require(:account).permit Account::ACCOUNT_PARAMS
  end
end
