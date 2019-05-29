class UserMailer < ApplicationMailer
  def order_email user, order
    @user = user
    @order = order
    mail to: @user.email, subject: t("email.order")
  end

  def admin_email user, order
    @user = user
    @order = order
    mail to: @user.email, subject: t("email.order", name: @user.name)
  end
end
