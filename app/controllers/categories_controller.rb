class CategoriesController < ApplicationController
  authorize_resource
  before_action :load_all_categories
  before_action :load_category, only: %i(edit update destroy)

  def index; end

  def new
    @category = Category.new
    render :index
  end

  def edit
    render :index
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "flash.create_ok", name: t("label.category")
    end
    render :index
  end

  def update
    if @category&.update_attributes category_params
      flash[:success] = t "flash.update_ok", name: t("label.category")
    end
    render :index
  end

  def destroy
    return render :index unless @category
    begin
      Category.transaction do
        @category.children.each{|c| c.update_attribute(:parent_id, nil)}
        if @category.products.any?
          del_category_soft!
        else
          @category.destroy
        end
      end
      flash[:success] = t "flash.del_ok", name: t("label.category")
    rescue StandardError
      flash[:danger] = t "flash.nil_object", name: t("label.category")
    end
    redirect_to :categories
  end

  private

  def del_category_soft!
    @category.products.each{|p| del_product_soft!(p)}
    @category.destroy
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = t "flash.nil_object", name: t("label.category")
    redirect_to :categories
  end

  def load_all_categories
    @categories = Category.all.paginate page: params[:page]
  end

  def category_params
    params.require(:category).permit :name, :parent_id
  end
end
