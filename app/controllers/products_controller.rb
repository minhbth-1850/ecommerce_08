class ProductsController < ApplicationController
  before_action :logged_in_user, :logged_as_admin, except: :show
  before_action :load_product, only: %i(show edit update destroy)
  before_action :load_review, only: :show

  def index
    @products = load_all_products Settings.products.per_page
    respond_to do |format|
      format.html
      format.csv do
        if Settings.products.tmp_type == params[:type].to_i
          send_data Product.to_template, filename: "productTmp.csv"
        else
          send_data Product.all.to_csv, filename: "productAll.csv"
        end
      end
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "flash.create_ok", name: t("label.product")
      redirect_to :products
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @product.update_attributes product_params
      flash[:success] = t "flash.update_ok", name: t("label.product")
      redirect_to :products
    else
      render :edit
    end
  end

  def destroy
    if @product.update_attribute(:activated, false)
      flash[:success] = t "flash.del_ok", name: t("label.product")
      check_del_product @product
      redirect_to :products
    else
      flash[:danger] = t "flash.nil_object", name: t("label.product")
      redirect_to root_path
    end
  end

  def import
    if params[:file].present?
      counter = Product.import(params[:file].path)
      flash[:success] = t("product.import", count: counter)
    end
    redirect_to :products
  end

  private

  def load_product
    @product = Product.activates.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "flash.nil_object", name: "product"
    redirect_to root_path
  end

  def load_review
    @reviews = @product.reviews.paginate page: params[:page],
      per_page: Settings.products.review_page
    @review = @product.reviews.find_by(user_id: current_user)
    @review ||= Review.new
  end

  def product_params
    params.require(:product).permit :name, :info, :category_id,
      :quantity, :price, :image
  end
end
