class CartController < ApplicationController
  include CartHelper

  def shoping
    add_product params[:cart][:product_id]
    respond_to do |format|
      format.html{redirect_to cart_path}
      format.js
    end
  end

  def show
    orders = load_cookie_cart
    load_products orders
  end

  def destroy
    orders = remove_product params[:product_id]
    load_products orders
    render :show
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
      p.quantity = orders[p.id.to_s]
    end
  end
end
