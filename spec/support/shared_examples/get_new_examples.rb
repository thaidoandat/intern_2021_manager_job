RSpec.shared_examples "render :new view" do
  describe "GET #new" do
    it "should render the :new view" do
      get :new
      expect(response).to render_template :new
    end
  end
end
