class UsersController < ApplicationController
  include UsersHelper

  before_action :logged_in_user, except: %i(new create)
  before_action :logged_as_admin, only: %i(index destroy)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: :edit

  def index
    option = load_params_option(params[:sort_id].to_i)
    @users = User.activates.order_option(option).paginate page: params[:page],
      per_page: Settings.users.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "label.welcome", logo: t("logo")
      log_in @user

      redirect_to @user
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flash.profile_update"
      redirect_to current_user.admin? ? :users : @user
    else
      render :edit
    end
  end

  def destroy
    if @user.update_attribute(:activated, false)
      flash[:success] = t "flash.del_ok", name: t("label.user")
      check_del_user @user
      redirect_to :users
    else
      flash[:danger] = t "flash.nil_object", name: t("label.user")
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :phone, :address,
      :password, :password_confirmation, :role
  end

  def correct_user
    return if current_user.admin? || current_user?(@user)

    flash[:danger] = t "flash.login_plz"
    redirect_to root_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return @user if @user

    flash[:danger] = t "flash.nil_object", name: "User"
    redirect_to root_path
  end
end
