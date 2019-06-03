class ApplicationController < ActionController::Base
  include SessionsHelper
  include ProductsHelper
  include CartHelper

  before_action :set_locale

  # users
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.login_plz"
    redirect_to login_path
  end

  def logged_as_admin
    return if current_user.admin?

    store_location
    flash[:danger] = t "flash.login_admin"
    redirect_to login_path
  end

  # products
  def del_product_soft! product
    cancel_order_product product
    product.update_attribute(:activated, false)
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
