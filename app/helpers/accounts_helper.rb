module AccountsHelper
  def role_options
    role_list = Account::ROLES_HASH.keys.reject{|item| item == :admin}
    role_list.map{|key| [key.capitalize, key]}
  end
end
