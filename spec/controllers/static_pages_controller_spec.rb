require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  describe "GET /home" do
    before do
      get :home
    end
    it "should load data" do
      expect(response.response_code).to eq 200
    end

    it "should render home page" do
      expect(response).to render_template :home
    end
  end
end
