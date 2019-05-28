module OrdersHelper
  def get_price_order order
    total = 0
    order.order_products.each do |placement|
      total += placement.quantity * placement.product.price
    end
    total
  end

  def show_state state
    class_type = case state
                 when "failed"
                   "btn btn-danger"
                 when "completed"
                   "btn btn-success"
                 when "cancelled"
                   "btn btn-secondary"
                 else
                   "btn btn-warning"
                 end
    "<div class=\"#{class_type}\">#{state}</div>".html_safe
  end
end
