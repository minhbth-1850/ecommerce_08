class StatisticsController < ApplicationController
  authorize_resource class: false

  def show
    @users = User.activates.select(:created_at)
    @order_products = OrderProduct.chart_product
    @orders = Order.select(:created_at)
    @cancel_orders = Order.cancelled.select(:updated_at)
  end
end
