# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def order_email_preview
    UserMailer.order_email(User.first, Order.first)
  end

  def admin_email_preview
    UserMailer.admin_email(User.first, Order.first)
  end
end
