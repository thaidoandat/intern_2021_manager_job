class AdminCompaniesController < AdminController
  before_action :check_role_admin, only: :index

  def index
    @admin_companies = Company.by_name(params[:name]).page(params[:page])
                              .per Settings.jobs.max_items_per_page
  end
end
