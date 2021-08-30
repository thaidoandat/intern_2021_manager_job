module OwnerHelper
  def current_owner
    redirect_to login_path unless account_signed_in?

    if current_account.user? && current_account.user
      current_account.user
    elsif current_account.company? && current_account.company
      current_account.company
    end
  end
end
