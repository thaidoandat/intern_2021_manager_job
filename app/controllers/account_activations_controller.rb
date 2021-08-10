class AccountActivationsController < ApplicationController
  def edit
    account = Account.find_by email: params[:email]
    if account && !account.activated? &&
       account.authenticated?(:activation, params[:id])
      account.activate
      log_in account
      flash[:success] = t "accounts.create.success"
      redirect_register_information account
    else
      flash[:danger] = t "accounts.create.failure"
      render :new
    end
  end

  private

  def redirect_register_information account
    redirect_to new_user_path if account.user?

    redirect_to new_company_path if account.company?
  end
end
