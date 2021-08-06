module ApplicationHelper
  def profile_link
    return current_owner if current_owner

    if current_account.user?
      new_user_path
    elsif current_account.company?
      new_company_path
    else
      root_path
    end
  end
end
