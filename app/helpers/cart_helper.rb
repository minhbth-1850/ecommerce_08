module CartHelper
  def load_cookie_cart
    @orders = cookies[:orders].blank? ? Hash.new : JSON.parse(cookies[:orders])
  end

  def save_cookie_cart orders
    cookies.permanent[:orders] = JSON.generate orders
  end

  def clear_cart
    save_cookie_cart Hash.new
  end

  def add_product product_id
    load_cookie_cart
    if @orders.key? product_id
      @orders[product_id] += 1
    else
      @orders[product_id] = 1
    end
    save_cookie_cart @orders
  end

  def remove_product product_id
    load_cookie_cart
    return @orders unless @orders.key?(product_id)

    quantity = @orders[product_id]
    if quantity <= 1
      @orders.delete(product_id)
    else
      @orders[product_id] = quantity - 1
    end
    save_cookie_cart @orders
    @orders
  end

  def load_size_cart
    load_cookie_cart
    @orders.values.sum
  end

  def get_total_price products
    products.reduce(0) do |sum, p|
      sum + p.get_total_price
    end
  end
end
