require "rails_helper"

describe AccountsController, type: :controller do
  let!(:params){FactoryBot.attributes_for(:account)}
  let!(:account_params){{account: params}}

  before{@request.env["devise.mapping"] = Devise.mappings[:account]}

  it_behaves_like "render :new view"

  describe "POST #create" do
    let!(:count_before){Account.count}

    context "when params is valid" do
      before do
        post :create, params: account_params
      end

      it_behaves_like "create a new object successfully", Account

      it "redirect to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "when params is invalid" do
      before do
        account_params[:account][:email] = ""
        post :create, params: account_params
      end

      it_behaves_like "create a new object failed", Account

      it "redirect to new_user_path" do
        expect(response).to render_template :new
      end
    end
  end
end
