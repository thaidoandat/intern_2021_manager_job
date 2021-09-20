require "rails_helper"
require "pry"
include ApplicationHelper

describe CompaniesController, type: :controller do
  let!(:account_company){FactoryBot.create :account, role: "company"}
  let!(:account_company2){FactoryBot.create :account, role: "company"}
  let!(:account_user){FactoryBot.create :account, role: "user"}
  let!(:company){FactoryBot.create :company, account_id: account_company.id}
  let!(:user){FactoryBot.create :user, account_id: account_user.id}
  let!(:company_params){FactoryBot.attributes_for(:company)}
  let(:params){{company: company_params}}

  before{sign_in account_company}

  it_behaves_like "render :new view"

  describe "POST #create" do
    let!(:count_before){Company.count}
    before do
      sign_out account_company
      sign_in account_company2
    end

    context "when company information is valid" do
      before{post :create, params: params}

      it "should flash provide information successfully" do
        expect(flash[:success]).to eq I18n.t("controller.provide_info_success")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end

      it_behaves_like "create a new object successfully", Company
    end

    context "when company information is invalid" do
      before do
        params[:company][:name] = "hi"
        post :create, params: params
      end

      it "should render template new" do
        expect(response).to render_template :new
      end

      it "should send error message to invalid field" do
        expect(assigns(:company).errors.messages[:name]).to be_present
      end

      it_behaves_like "create a new object failed", Company
    end
  end

  describe "GET #show" do
    context "when company not found" do
      before{get :show, params: {id: -1}}

      it "should flash company not found" do
        expect(flash[:warning]).to eq I18n.t("controller.company_not_found")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when company found" do
      before{get :show, params: {id: company.id}}

      it "should render template show" do
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #edit" do
    context "when company not found" do
      before{get :show, params: {id: -1}}

      it "should flash company not found" do
        expect(flash[:warning]).to eq I18n.t("controller.company_not_found")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when logged in and not current company" do
      before do
        sign_out account_company
        sign_in account_user
        get :edit, params: {id: company.id}
      end

      it "should flash no permission" do
        expect(flash[:alert]).to eq I18n.t("controller.no_permission")
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when logged in and be current company" do
      before{get :edit, params: {id: company.id}}

      it "should render template edit" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let!(:current_updated_at){company.updated_at}

    context "when update successfully" do
      before do
        params[:id] = company.id
        patch :update, params: params
      end

      it "should flash update profile successfully" do
        expect(flash[:success]).to eq I18n.t("controller.profile_updated")
      end

      it "should redirect to current_owner's profile" do
        expect(response).to redirect_to company
      end

      it "should change updated at field" do
        expect(company.reload.updated_at).to_not eq(current_updated_at)
      end
    end

    context "when update failed" do
      before do
        params[:id] = company.id
        params[:company][:name] = "hi"
        patch :update, params: params
      end

      it "should flash update failed" do
        expect(flash[:danger]).to eq I18n.t("controller.profile_update_failed")
      end

      it "should render template edit" do
        expect(response).to render_template :edit
      end
    end
  end
end
