require "rails_helper"

describe AccountsController, type: :controller do
  let!(:params){FactoryBot.attributes_for(:account)}
  let!(:account_params){{account: params}}

  before{@request.env["devise.mapping"] = Devise.mappings[:account]}

  describe "GET #new" do
    it "should render the :new view" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    let!(:account_count){Account.count}

    context "when params is valid" do
      before do
        post :create, params: account_params
      end

      it "increase number of account by 1" do
        expect(Account.count).to eq(account_count + 1)
      end

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when params is invalid" do
      before do
        account_params[:account][:email] = ""
        post :create, params: account_params
      end

      it "don't change number of account" do
        expect(Account.count).to eq(account_count)
      end

      it "redirect to new_user_path" do
        expect(response).to render_template :new
      end
    end
  end
end
