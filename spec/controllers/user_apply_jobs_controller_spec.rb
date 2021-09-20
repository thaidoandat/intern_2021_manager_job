require "rails_helper"

RSpec.describe UserApplyJobsController, type: :controller do  
  let(:user_info_1){FactoryBot.create :user_info}
  let(:account_1){user_info_1.user.account}
  let(:account_2){FactoryBot.create :account, role: "user"}
  let(:account_3){FactoryBot.create :account, role: "company"}
  let(:company){FactoryBot.create :company, account: account_3}
  let(:job){FactoryBot.create :job, company: company}
  let!(:params) {{job_id: job.id, user: FactoryBot.attributes_for(:user)}}

  describe "GET /new" do
    context "when current account is user but it's info is nil" do
      before do
        sign_in account_2
        get :new
      end

      it "redirect to new_user_path" do
        expect(response).to redirect_to new_user_path
      end
    end

    context "when current account is company" do
      before do
        sign_in account_3
        get :new
      end

      it "popup no_permission flash warning" do
        expect(flash[:alert]).to eq I18n.t("controller.no_permission")
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when valid account" do
      before do
        sign_in account_1
        get :new
      end

      it "render :new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST /create" do
    let!(:count_before){UserApplyJob.count}

    before {sign_in account_1}

    context "when params is valid" do
      before do
        post :create, params: params
      end

      it_behaves_like "create a new object successfully", UserApplyJob

      it "redirect to user_path" do
        expect(response).to redirect_to account_1.user
      end
    end

    context "when params is invalid" do
      before do
        params[:user][:name] = ""
        post :create, params: params
      end

      it_behaves_like "create a new object failed", UserApplyJob
    end
  end
end
