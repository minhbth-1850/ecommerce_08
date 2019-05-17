class ProductsController < ApplicationController
  before_action :load_category, only: %i(new index)
  before_action :load_product, only: %i(edit update destroy)

  def new
    @product = Product.new
  end

  def index
    @products = if params[:category_id].blank?
                  Product.load_category.paginate page: params[:page], per_page: 10
                else
                  @parent_ids = load_category_chilrens params[:category_id].to_i
                  Product.load_category
                         .where(category_id: @parent_ids)
                         .paginate page: params[:page], per_page: 10
                end
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

  def update
    if @product.update_attributes product_params
      flash[:success] = t "message.profile_update"
      redirect_to :products
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t "message.user_del"
      redirect_to :products
    else
      flash[:danger] = t "message.nil_user"
      redirect_to root_path
    end
  end

  private

  def product_params
    params.require(:product).permit :name, :info, :image,
      :quantity, :price, :category_id
  end

  def load_category
    @categories = Category.all
  end

  def load_product
    @product = Product.find_by id: params[:id]
  end

  def load_category_chilrens id
    @parent_ids = [id]
    while id.present? do
      @categories.each do |cat|
        if id == cat.parent_id
          @parent_ids << cat.id
          id = cat.id
          next
        end
      end
      id = nil;
    end
    @parent_ids
  end
end
