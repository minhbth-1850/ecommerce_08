class CartController < ApplicationController
  def shoping
    add_product params[:cart][:product_id], params[:cart][:quantity].to_i
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.js
    end
  end

  def show
    orders = load_cookie_cart
    load_products orders
  end

  def update
    update_cart params[:product_id], params[:quantity].to_i
    redirect_to cart_path
  end

  def destroy
    remove_product params[:product_id]
    redirect_to cart_path
  end

  def checkout
    orders = load_cookie_cart
    load_products orders
    render :payment
  end

  private

  def load_products orders
    @products = Product.find_ids(orders.keys)
    @products.each do |p|
      p.amount_added = orders[p.id.to_s]
    end
  end
end
