class ProductsController < ApplicationController
  before_action :load_category, only: :new

  def new
    @product = Product.new
  end

  def index
    @products = Product.includes(:category).all
  end

  def show; end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "label.welcome", logo: t("link.logo")
      redirect_to :products
    else
      render :new
    end
  end

  def edit; end

  def update; end

  private

  def product_params
    params.require(:product).permit :name, :info, :image,
      :quantity, :price, :category_id
  end

  def load_category
    @categories = Category.all
  end

  def load_product
    @product = Product.includes(:category).find_by id: params[:id]
  end
end
