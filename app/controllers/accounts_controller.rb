class AccountsController < ApplicationController
  def new
    redirect_to root_path if logged_in?

    @account = Account.new
  end

  def create
    @account = Account.new account_params
    return render :new unless @account.save

    @account.send_activation_email
    flash[:info] = t "accounts.create.check_email_to_activate"
    redirect_to root_path
  end

  private

  def account_params
    params.require(:account).permit Account::ACCOUNT_PARAMS
  end
end
