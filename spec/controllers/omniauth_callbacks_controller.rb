require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user_facebook = OmniAuth.config.mock_auth[:facebook]
    @request.env["omniauth.auth"] = @user_facebook
  end

  describe "GET #facebook" do
    it "should successfully sign in user" do
      get :facebook
      expect(flash[:notice]).to include(I18n.t("devise.omniauth_callbacks.success", kind: "Facebook"))
      expect(response).to redirect_to root_path
      expect(subject.current_user).to_not be_nil
    end

    it "should exist user in database" do
      get :facebook
      expect(User.find_by(email: @user_facebook.info.email)).to_not be_nil
    end
  end
end
