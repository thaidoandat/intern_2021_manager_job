class StaticPagesController < ApplicationController
  def home
    @jobs = Job.newest.includes(:company).page(params[:job_page])
               .per Settings.jobs.max_items_per_page
    @companies = Company.all.page(params[:company_page])
                        .per Settings.jobs.max_items_per_page
    @search = Job.ransack
  end
end
