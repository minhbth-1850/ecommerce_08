class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include ProductsHelper
  include CartHelper
  include UsersHelper

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?
  before_action :load_search_form

  # users
  def logged_as_admin
    return if current_user.admin?
    flash[:danger] = t("flash.login_admin")
    redirect_to root_path
  end

  # products
  def del_product_soft! product
    cancel_order_product product
    product.update_attribute(:activated, false)
  end

  # cancan override
  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:danger] = exception.message
      redirect_to root_path
    else
      flash[:danger] = t("flash.login_plz")
      redirect_to new_user_session_path
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me, :address, :phone]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end


  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def cancel_order_product product
    orders = product.orders.processing
    orders.each do |order|
      UserMailer.order_email(order.user, order).deliver_now if order.cancelled!
    end
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def load_search_form
    @q = Product.ransack(params[:q])
  end
end
