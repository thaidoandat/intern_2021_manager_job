class ProcessCandidatesController < ApplicationController
  before_action :find_user_apply_job

  def update
    if @user_apply_job.pending? && @user_apply_job.accepted!
      flash[:success] = t "process_candidates.update.success"
    else
      flash[:danger] = t "process_candidates.update.fail"
    end
    redirect_to current_owner
  end

  def destroy
    if @user_apply_job.destroy
      flash[:success] = t "process_candidates.destroy.success"
    else
      flash[:danger] =  t "process_candidates.destroy.fail"
    end
    redirect_to current_owner
  end

  private

  def find_user_apply_job
    @user_apply_job = UserApplyJob.find_by id: params[:id]
    return if @user_apply_job

    flash[:danger] = t "process_candidates.apply_not_found"
    redirect_to root_path
  end
end
