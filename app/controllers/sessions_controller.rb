class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    @referer_url = root_path
    super
  end

  def destroy
    @referer_url = root_path
    super
  end
end
