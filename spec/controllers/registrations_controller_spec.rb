require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :controller do
  fixtures :users
  let(:user) {users.first}
  let(:user_params) do
    {name: Faker::Name.name,
     email: "user@example.com",
     phone: "012346578941",
     address: Faker::Name.name,
     password: "123456",
     password_confirmation: "123456"}
  end

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def expect_msg_error attribute, msg
    errore_msg = assigns(:user).errors.messages
    expect(errore_msg).to include(attribute => including(msg))
  end

  describe "GET #new" do
    it "when yet login should render sign up page" do
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
        expect(flash[:notice]).to eq I18n.t("devise.registrations.signed_up_but_unconfirmed")
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid attributes" do
      it "when name blank don't create user" do
        user_params[:name] = ""
        post :create, params: {user: user_params}
        expect(subject).to render_template :new
        errore_msg = assigns(:user).errors.messages
        expect(errore_msg).to include(name: including(I18n.t("errors.messages.blank")))
      end

      it "when email blank don't create user" do
        user_params[:email] = ""
        post :create, params: {user: user_params}
        expect(subject).to render_template :new
        expect_msg_error :email, I18n.t("errors.messages.blank")
      end

      it "when email exist don't create user" do
        user_params[:email] = user.email
        post :create, params: {user: user_params}
        expect(subject).to render_template :new
        expect_msg_error :email, I18n.t("errors.messages.taken")
      end

      it "when address blank do not create user" do
        user_params[:address] = ""
        post :create, params: {user: user_params}
        expect(subject).to render_template :new
        expect_msg_error :address, I18n.t("errors.messages.blank")
      end

      it "confirmation password should be true" do
        user_params[:password] = "123456"
        user_params[:password_confirmation] = "1111111"
        post :create, params: {user: user_params}
        expect_msg_error :password_confirmation, I18n.t("errors.messages.confirmation",
          attribute: "Password")
      end
    end
  end

  describe "GET #edit" do
    before :each do
      sign_in user
    end

    it "should render edit page" do
      get :edit
      expect(response).to have_http_status :success
      expect(subject).to render_template :edit
    end

    it "when loggin yet return login path" do
      sign_out user
      get :edit
      expect(flash[:alert]).to eq I18n.t("devise.failure.unauthenticated")
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "PATCH #update" do
    before :each do
      sign_in user
    end

    context "valid attributes" do
      it "change user's attributes" do
        new_name = Faker::Name.name
        user_params[:name] = new_name
        patch :update, params: {user: user_params}
        user.reload
        expect(user.name).to eq new_name
      end
    end

    context "invalid attributes" do
      it "does not change user's attributes" do
        fail_name = " "
        user_params[:name] = fail_name
        patch :update, params: {id: user.id, user: user_params}
        user.reload
        expect(user.name).to_not eq fail_name
        expect(subject).to render_template :edit
      end
    end
  end
end
