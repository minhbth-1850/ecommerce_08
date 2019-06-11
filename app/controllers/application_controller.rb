class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include ProductsHelper
  include CartHelper
  include UsersHelper

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  protected

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me, :address, :phone]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
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
end
