class AdminCompaniesController < AdminController
  before_action :check_role_admin, only: :index

  def index
    @search = Company.ransack params[:q]
    @admin_companies = @search.result.page(params[:page])
                              .per Settings.jobs.max_items_per_page
  end
end
