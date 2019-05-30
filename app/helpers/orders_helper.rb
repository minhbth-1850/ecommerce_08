module OrdersHelper
  def get_price_order order
    total = 0
    order.order_products.each do |placement|
      total += placement.quantity * placement.product.price
    end
    total
  end

  def show_state state
    name_state = I18n.t("order_state")[state.to_sym]
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
    "<div class=\"#{class_type}\">#{name_state}</div>".html_safe
  end

  def load_order_states
    Order.states.map{|k, _v| [I18n.t("order_state")[k.to_sym], k]}
  end
end
