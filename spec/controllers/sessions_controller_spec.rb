require "rails_helper"

RSpec.describe Devise::SessionsController, type: :controller do
  fixtures :users
  let(:user) {users.first}
  let(:user_params) do
    {email: user.email,
     password: "password"}
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET #new" do
    it "when yet login should render sign in page" do
      get :new
      expect(response).to have_http_status :success
      expect(subject).to render_template :new
    end

    it "when logged in should render home page" do
      sign_in user
      get :new
      expect(flash[:alert]).to eq I18n.t("devise.failure.already_authenticated")
      expect(response).to redirect_to root_path
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "created new user" do
        post :create, params: {user: user_params}
        expect(flash[:notice]).to eq I18n.t("devise.sessions.signed_in")
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid attributes" do
      it "should render sign in page" do
        user_params[:password] = " "
        post :create, params: {user: user_params}
        expect(flash[:alert]).to eq I18n.t("devise.failure.invalid", authentication_keys: "Email")
        expect(subject).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    it "sign out user" do
      get :destroy
      expect(flash[:notice]).to eq I18n.t("devise.sessions.signed_out")
      expect(response).to redirect_to root_path
    end
  end
end
