class CategoriesController < ApplicationController
  before_action :logged_as_admin, only: %i(new create)

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "flash.create_ok", name: t("label.category")
      redirect_to :products
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :parent_id
  end
end
