require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  let!(:account){FactoryBot.create :account}

  before{@request.env["devise.mapping"] = Devise.mappings[:account]}

  it_behaves_like "render :new view"

  describe "POST /create" do
    context "when login with correct params" do
      before do
        post :create, params: {account: {email: account.email, password: account.password}}
      end

      it "redirect to root page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when login with wrong params" do
      before do
        post :create, params: {account: {email: account.email, password: ""}}
      end

      it "render template new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE /destroy" do
    context "when account login" do
      before do
        sign_in account
        delete :destroy
      end

      it "redirect to root page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when account not login" do
      before do
        delete :destroy
      end

      it "redirect to root page" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
