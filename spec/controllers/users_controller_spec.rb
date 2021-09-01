require "rails_helper"
include ApplicationHelper

RSpec.describe UsersController, type: :controller do
  let(:account_1){FactoryBot.create :account, role: "user"}
  let(:account_2){FactoryBot.create :account, role: "company"}

  let(:user_info_3){FactoryBot.create :user_info}
  let(:user_info_4){FactoryBot.create :user_info}

  let(:account_3){user_info_3.user.account}
  let(:account_4){user_info_4.user.account}

  let!(:user_params) {FactoryBot.attributes_for(:user)}
  let!(:user_info_params) {FactoryBot.attributes_for(:user_info)}

  before do
    user_params[:user_info_attributes] = user_info_params
  end

  let(:params) {{user: user_params}}

  describe "GET #new" do
    context "when current account is user" do
      before do
        sign_in account_1
        get :new
      end

      it "render :new" do
        expect(response).to render_template :new
      end
    end

    context "when current account is not user" do
      before do
        sign_in account_2
        get :new
      end

      it "popup no_permission flash warning" do
        expect(flash[:alert]).to eq I18n.t("controller.no_permission")
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    let!(:user_count){User.count}

    before {sign_in account_1}

    context "when params is valid" do
      before do
        post :create, params: params
      end

      it "increase number of user by 1" do
        expect(User.count).to eq(user_count + 1)
      end

      it "popup provide_info_success flash" do
        expect(flash[:success]).to eq I18n.t("controller.provide_info_success")
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when params is invalid" do
      before do
        params[:user][:name] = ""
        post :create, params: params
      end

      it "don't change number of user" do
        expect(User.count).to eq(user_count)
      end

      it "popup provide_info_failed flash" do
        expect(flash[:danger]).to eq I18n.t("controller.provide_info_failed")
      end

      it "redirect to new_user_path" do
        expect(response).to redirect_to new_user_path
      end
    end
  end

  describe "GET #show" do
    context "when user not exist" do
      before {get :show, params: {id: -1}}

      it "popup user_not_found flash" do
        expect(flash[:warning]).to eq I18n.t("controller.user_not_found")
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when user existed" do
      before do
        get :show, params: {id: account_3.user.id}
      end

      it "render :show" do
        expect(response).to render_template :show
      end
    end
  end

  describe "GET /edit" do
    context "when user not exist" do
      before {get :edit, params: {id: -1}}

      it "popup user_not_found flash" do
        expect(flash[:warning]).to eq I18n.t("controller.user_not_found")
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when not current user" do
      before do
        sign_in account_4
        get :edit, params: {id: account_3.user.id}
      end

      it "popup no_permission flash" do
        expect(flash[:alert]).to eq I18n.t("controller.no_permission")
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when user is current user" do
      before do
        sign_in account_3
        get :edit, params: {id: account_3.user.id}
      end

      it "render :edit" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH /update" do
    let!(:previous_name){account_3.user.name}

    before {sign_in account_3}

    context "when update successfully" do
      before do
        params[:id] = account_3.user.id
        patch :update, params: params
      end

      it "change user name" do
        expect(account_3.reload.user.name).to_not eq(previous_name)
      end

      it "popup profile_updated flash" do
        expect(flash[:success]).to eq I18n.t("controller.profile_updated")
      end

      it "redirect to current_owner" do
        expect(response).to redirect_to account_3.user
      end
    end

    context "when update failed" do
      before do
        params[:id] = account_3.user.id
        params[:user][:name] = ""
        patch :update, params: params
      end

      it "don't change user name" do
        expect(account_3.reload.user.name).to eq(previous_name)
      end

      it "popup profile_update_failed flash" do
        expect(flash[:danger]).to eq I18n.t("controller.profile_update_failed")
      end

      it "render :edit" do
        expect(response).to render_template :edit
      end
    end
  end
end
