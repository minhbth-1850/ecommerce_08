class ProductsController < ApplicationController
  before_action :load_product, :load_review, only: :show

  def show; end

  private

  def load_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "flash.nil_object", name: "product"
    redirect_to root_path
  end

  def load_review
    @review = @product.reviews.find_by(user_id: current_user)
    @review ||= Review.new
  end
end
