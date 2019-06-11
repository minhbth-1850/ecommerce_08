class UsersController < ApplicationController
  include UsersHelper
  before_action :authenticate_user!
  before_action :logged_as_admin, only: %i(index destroy)
  before_action :load_user, except: %i(index new create)

  def index
    option = load_params_user(params[:sort_id].to_i)
    @users = User.activates.order_option(option).paginate page: params[:page],
      per_page: Settings.users.per_page
  end

  def profile
    render :show
  end

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

  def load_user
    @user = User.find_by id: params[:id]
    return @user if @user

    flash[:danger] = t "flash.nil_object", name: "User"
    redirect_to root_path
  end
end
