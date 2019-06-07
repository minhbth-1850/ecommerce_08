require "rails_helper"

RSpec.describe Devise::PasswordsController, type: :controller do
  fixtures :users
  let(:user) {users.first}

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET #new" do
    it "when yet login should render forgot password page" do
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
      it "send email reset password" do
        post :create, params: {user: {email: user.email}}
        expect(flash[:notice]).to eq I18n.t("devise.passwords.send_instructions")
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "with invalid attributes" do
      it "when blank email should render forgot form" do
        post :create, params: {user: {email: " "}}
        errore_msg = assigns(:user).errors.messages
        expect(errore_msg).to include(email: including(I18n.t("errors.messages.blank")))
        expect(subject).to render_template :new
      end

      it "when wrong email should render forgot form" do
        post :create, params: {user: {email: "worng@email.com"}}
        errore_msg = assigns(:user).errors.messages
        expect(errore_msg).to include(email: including(I18n.t("errors.messages.not_found")))
        expect(subject).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @token = user.send_reset_password_instructions
      user.reset_password_sent_at = Time.now
      user.save
    end

    it "should render edit page" do
      get :edit, params: {reset_password_token: @token}
      expect(response).to have_http_status :success
      expect(subject).to render_template :edit
    end
  end

  describe "PATCH #update" do
    before :each do
      @token = user.send_reset_password_instructions
      user.reset_password_sent_at = Time.now
      user.save
    end

    context "with invalid attributes" do
      it "when token invalid should change password" do
        new_pass = "123456"
        patch :update, params: {user: {reset_password_token: "12465",
                                       password: new_pass,
                                       pasword_confimation: new_pass}}
        expect(subject).to render_template :edit
        errore_msg = assigns(:user).errors.messages
        expect(errore_msg).to include(reset_password_token: including(I18n.t("errors.messages.invalid")))
      end

      it "when password blank should change password" do
        new_pass = " "
        patch :update, params: {user: {reset_password_token: @token,
                                       password: new_pass,
                                       pasword_confimation: new_pass}}
        expect(subject).to render_template :edit
        errore_msg = assigns(:user).errors.messages
        expect(errore_msg).to include(password: including(I18n.t("errors.messages.blank")))
      end
    end

    context "with valid attributes" do
      it "send email reset password" do
        old_pass = user.encrypted_password
        new_pass = "new123465"
        patch :update, params: {user: {reset_password_token: @token,
                                       password: new_pass,
                                       pasword_confimation: new_pass}}
        expect(user.reload.encrypted_password).to_not eq old_pass
        expect(user.valid_password? new_pass).to eq true
        expect(flash[:notice]).to eq I18n.t("devise.passwords.updated")
        expect(response).to redirect_to root_path
      end
    end
  end
end
