require "rails_helper"
include SessionsHelper

RSpec.describe JobsController, type: :controller do
  let(:account1){FactoryBot.create :account, role: "company"}
  let(:account2){FactoryBot.create :account, role: "company"}
  let(:account3){FactoryBot.create :account, role: "company"}
  let(:account4){FactoryBot.create :account, role: "user"}

  let!(:company1){FactoryBot.create :company, account: account1}
  let!(:company2){FactoryBot.create :company, account: account2}

  let(:job1){FactoryBot.create :job, company: company1}
  let(:job2){FactoryBot.create :job, company: company2}

  let!(:job_params){{job: FactoryBot.attributes_for(:job)}}

  let!(:salary){FactoryBot.create :salary, id: 1, min_salary: 1000, max_salary: 10000}

  before do
    log_in account1
  end

  describe "GET /index" do
    context "when go to job index page" do
      before do
        get :index
      end

      it "should redirect to jobs_url" do
        expect(response.response_code).to eq 200
      end
    end

    context "when use job filter without choose selection" do
      before do
        get :index, params: {commit: 1}
      end

      it "should return all job" do
        expect(response.response_code).to eq 200
      end

      it "should render index page" do
        expect(response).to render_template :index
      end
    end

    context "when use job filter with some selection" do
      before do
        get :index, params: {commit: 1, salary_id: "1"}
      end

      it "should return suitable job" do
        expect(response.response_code).to eq 200
      end

      it "should render suitable job" do
        expect(response).to render_template :index
      end
    end
  end

  describe "GET /new" do
    context "when current account belongs to user" do
      before do
        log_out
        log_in account4
        get :new
      end

      it "should redirect to root path" do
        expect(response).to redirect_to root_url
      end
    end

    context "when logged in but haven't had company info" do
      before do
        log_out
        log_in account3
        get :new
      end

      it "should redirect to new_company_url" do
        expect(response).to redirect_to new_company_url
      end
    end

    context "when account logged in and had company info" do
      before do
        get :new
      end

      it "should redirect to new_job_url" do
        expect(response.response_code).to eq 200
      end
    end
  end

  describe "POST /create" do
    context "when job information is valid" do
      before do
        create_params = job_params
        create_params[:job][:job_categories] = {"1" => "1", "2" => "1"}
        post :create, params: job_params
      end

      it "should redirect to job information" do
        expect(assigns(:job)).to eq company1.jobs.last
      end
    end

    context "when job information is invalid" do
      before do
        post :create, params: {job: {name: ""}}
      end

      it "should render new job template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET /show" do
    context "when job not exist" do
      before do
        get :show, params: {id: -1}
      end

      it "should redirect to root_url" do
        expect(response).to redirect_to root_url
      end
    end

    context "when job exist" do
      before do
        get :show, params: {id: job1.id}
      end

      it "should redirect to job1 page" do
        expect(assigns(:job)).to eq job1
      end
    end
  end

  describe "GET /edit" do
    context "when job not exist" do
      before do
        get :edit, params: {id: -1}
      end

      it "should redirect to root url" do
        expect(response).to redirect_to root_url
      end
    end

    context "when job exist but not owned by current company" do
      before do
        get :edit, params: {id: job2.id}
      end

      it "should redirect to show page" do
        expect(assigns(:job)).to eq job2
      end
    end

    context "when job exist and owned by current company" do
      before do
        get :edit, params: {id: job1.id}
      end

      it "should @job equal job1" do
        expect(assigns(:job)).to eq job1
      end

      it "should render edit page" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH /update" do
    context "when update successfully" do
      before do
        update_params = job_params
        update_params[:id] = job1.id
        patch :update, params: update_params
      end

      it "should @job equal job1" do
        expect(assigns(:job)).to eq job1
      end

      it "should redirect to show job page" do
        expect(response).to redirect_to job1
      end
    end

    context "when update failed" do
      before do
        patch :update, params: {id: job1.id, job: {name: ""}}
      end

      it "should re-render edit job page" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE /destroy" do
    context "when job not exist" do
      before do
        delete :destroy, params: {id: -1}
      end

      it "should show flash danger" do
        expect(flash[:danger]).to eq I18n.t("controller.job_not_found")
      end

      it "should redirect to root_url" do
        expect(response).to redirect_to root_url
      end
    end

    context "when job exist but not owned by current company" do
      before do
        delete :destroy, params: {id: job2.id}
      end

      it "should redirect to show job page" do
        expect(response).to redirect_to job2
      end
    end

    context "when job exist and owned by current company" do
      before do
        delete :destroy, params: {id: job1.id}
      end

      it "should show flash success" do
        expect(flash[:success]).to eq I18n.t("jobs.destroy.success")
      end

      it "should redirect to show company page" do
        expect(response).to redirect_to company1
      end
    end
  end
end
