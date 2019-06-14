class SendMailJob < ApplicationJob
  queue_as :default
  retry_on StandardError, queue: :default, attempts: 5, wait: 5.minutes

  def perform order_id, is_admin = false

    order = Order.find(order_id)
    return unless order
    return UserMailer.admin_email(order.user, order).deliver_now if is_admin
    UserMailer.order_email(order.user, order).deliver_now
  end
end
