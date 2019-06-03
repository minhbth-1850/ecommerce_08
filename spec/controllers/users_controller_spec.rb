require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) { User.new(name: Faker::Name.name,
                       email: "user@example.com",
                       phone: "012346578941",
                       address: Faker::Name.name,
                       password: "123456",
                       password_confirmation: "123456") }
  let(:user_params) do
    {name: Faker::Name.name,
     email: "user@example.com",
     phone: "012346578941",
     address: Faker::Name.name,
     password: "123456",
     password_confirmation: "123456"}
  end

  describe "GET #index" do
    before :each do
      # before_action :logged_as_admin!
      user.role = "admin"
      user.save
      log_in_as user
    end

    it "should render index page"  do
      get :index, params: {id: user.id}
      expect(response).to have_http_status :success
      expect(subject).to render_template :index
    end

    it "when loggin yet return login path" do
      log_out
      get :index, params: {id: user.id}
      expect(response).to redirect_to login_path
    end

    it "when loggin as customer return login path" do
      user.role = "customer"
      user.save
      log_in_as user
      get :index, params: {id: user.id}
      expect(response).to redirect_to login_path
    end
  end

  describe "GET #new" do
    it "should render new page" do
      get :new
      expect(response).to have_http_status :success
      expect(subject).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "created new user" do
        post :create, params: {user: user_params}
        expect(flash[:success]).to eq I18n.t("label.welcome", logo: I18n.t("logo"))
        expect(response).to redirect_to user_path id: User.last
      end
    end

    context "with invalid attributes" do
      it "don't create user" do
        user_params[:name] = ""
        post :create, params: {user: user_params}
        expect(subject).to render_template :new
      end
    end
  end

  describe "GET #show" do
    before :each do
      user.save
      log_in_as user
    end

    it "should render show page"  do
      get :show, params: {id: user.id}
      expect(response).to have_http_status :success
      expect(assigns(:user)).to eq user
      expect(subject).to render_template :show
    end

    it "when loggin yet return login path" do
      log_out
      get :show, params: {id: user.id}
      expect(flash[:danger]).to eq I18n.t("flash.login_plz")
      expect(response).to redirect_to login_path
    end
  end

  describe "GET #edit" do
    before :each do
      user.save
      log_in_as user
    end

    it "should render edit page" do
      get :edit, params: {id: user.id}
      expect(response).to have_http_status :success
      expect(subject).to render_template :edit
    end

    it "when loggin yet return login path" do
      log_out
      get :edit, params: {id: user.id}
      expect(flash[:danger]).to eq I18n.t("flash.login_plz")
      expect(response).to redirect_to login_path
    end

    it "when not correct user" do
      log_out
      other_user = user.dup
      other_user.save
      log_in_as other_user
      get :edit, params: {id: user.id}
      expect(flash[:danger]).to eq I18n.t("flash.login_plz")
      expect(response).to redirect_to login_path
    end
  end

  describe "PATCH #update" do
    before :each do
      user.save
      log_in_as user
    end

    context "valid attributes" do
      it "change user's attributes" do
        new_name = Faker::Name.name
        user_params[:name] = new_name
        patch :update, params: {id: user.id, user: user_params}
        user.reload
        expect(user.name).to eq new_name
      end

      it "when customer redirects to the profile user" do
        user.role = "customer"
        user.save
        patch :update, params: {id: user.id, user: user_params}
        expect(flash[:success]).to eq I18n.t("flash.profile_update")
        expect(response).to redirect_to user_path user
      end

      it "when admin redirects to user index" do
        user.role = "admin"
        user.save
        patch :update, params: {id: user.id, user: user_params}
        expect(flash[:success]).to eq I18n.t("flash.profile_update")
        expect(response).to redirect_to users_path
      end
    end

    context "invalid attributes" do
      it "does not change user's attributes" do
        fail_name = " "
        user_params[:name] = fail_name
        patch :update, params: {id: user.id, user: user_params}
        user.reload
        expect(user.name).to_not eq fail_name
      end

      it "redirects to the edit user" do
        user_params[:name] = " "
        patch :update, params: {id: user.id, user: user_params}
        expect(flash[:success]).to be_nil
        expect(subject).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      user.role = "admin"
      user.save
      log_in_as user
    end

    it "delete user successful" do
      delete :destroy, params: {id: user.id}
      expect(flash[:success]).to eq I18n.t("flash.del_ok", name: I18n.t("label.user"))
      expect(response).to redirect_to users_path
    end
  end
end
