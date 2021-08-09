class StaticPagesController < ApplicationController
  before_action :current_account

  def home
    @jobs = Job.newest.includes(:company)
    @companies = Company.all
  end
end
