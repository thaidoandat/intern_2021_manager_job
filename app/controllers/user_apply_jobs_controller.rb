class UserApplyJobsController < ApplicationController
  before_action :authenticate_account!, :check_role_user,
                :get_user_info, except: %i(show)
  before_action :find_job, only: %i(create)

  def new
    redirect_to new_user_path if current_owner.nil?
  end

  def create
    if @user.update user_params
      @user.apply @job
      flash[:success] = t "controller.applied"
      redirect_to @user
    else
      flash[:danger] = t "controller.profile_update_failed"
      render :new
    end
  end

  def show
    @job = Job.includes(:company).find_by id: params[:id]
    @user_apply_jobs = @job.user_apply_jobs.includes(:user)
  end

  private
  def check_role_user
    return if current_account.user?

    redirect_to root_path
  end

  def get_user_info
    @user = current_account.user
    return root_path unless @user

    @user_info = UserInfo.find_by user_id: @user.id
  end

  def user_params
    params.require(:user).permit UserApplyJob::APPLY_PARAMS
  end
end
