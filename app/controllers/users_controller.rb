class UsersController < ApplicationController
  include UsersHelper

  authorize_resource
  before_action :load_user, only: %i(show edit update destroy)

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.activates.paginate page: params[:page],
      per_page: Settings.users.per_page
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

  def change_password
    @user = current_user
  end

  def update_password
    @user = current_user
    current_password = params[:user][:current_password]

    unless @user.valid_password? current_password
      @user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      return render :change_password
    end

    unless params[:user][:password].present?
      @user.errors.add(:password, :blank)
      return render :change_password
    end

    if @user.update_with_password(password_params)
      bypass_sign_in @user
      flash[:success] = t "flash.profile_update"
      redirect_to root_path
    else
      render :change_password
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :phone, :address, :role
  end

  def password_params
    params.require(:user).permit :password, :password_confirmation, :current_password
  end

  def load_user
    @user = User.find_by id: params[:id]
    return @user if @user

    flash[:danger] = t "flash.nil_object", name: "User"
    redirect_to root_path
  end
end
