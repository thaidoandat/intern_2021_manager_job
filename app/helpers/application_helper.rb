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

  def show_avatar avatar
    if avatar.attached?
      image_tag avatar
    else
      image_tag Settings.avatar.default
    end
  end
end
