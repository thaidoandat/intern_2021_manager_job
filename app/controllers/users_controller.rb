class UsersController < ApplicationController
  before_action :check_role_user, only: %i(new create)
  before_action :find_user, only: %i(show edit update)
  before_action :correct_user, only: %i(edit update)

  def new
    @user = current_account.build_user
    @user.build_user_info
  end

  def create
    @user = current_account.build_user user_params
    if @user.save_user_info user_info_params
      flash[:success] = t "controller.provide_info_success"
      redirect_to root_path
    else
      flash[:danger] = t "controller.provide_info_failed"
      redirect_to new_user_path
    end
  end

  def show
    @jobs = @user.jobs.includes(:company).newest.page(params[:page])
                 .per Settings.max_items_per_page
  end

  def edit
    return redirect_to new_user_path unless @user.user_info
  end

  def update
    if @user.update user_update_params
      flash[:success] = t "controller.profile_updated"
      redirect_to current_owner
    else
      flash[:danger] = t "controller.profile_update_failed"
      render :edit
    end
  end

  private
  def check_role_user
    return if current_account.user?

    flash[:warning] = t "controller.no_permission"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def user_info_params
    params.require(:user).require(:user_info_attributes)
          .permit UserInfo::USER_INFO_PARAMS
  end

  def user_update_params
    params.require(:user).permit User::UPDATE_PARAMS
  end

  def correct_user
    return if current_owner == @user

    redirect_to root_path
    flash[:warning] = t "controller.no_permission"
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "controller.user_not_found"
    redirect_to root_path
  end
end
