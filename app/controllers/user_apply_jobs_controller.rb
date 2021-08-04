class UserApplyJobsController < ApplicationController
  before_action :log_in_require, :get_user_info
  before_action :find_job, only: %i(create)

  def new; end

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

  private
  def get_user_info
    @user = User.find_by account_id: session[:account_id]
    return root_path unless @user

    @user_info = UserInfo.find_by user_id: @user.id
  end

  def user_params
    params.require(:user).permit UserApplyJob::APPLY_PARAMS
  end
end
