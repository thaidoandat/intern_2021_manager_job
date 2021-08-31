class AccountsController < Devise::RegistrationsController
  def new; end

  def create
    @referer_url = root_path
    super
  end
end
