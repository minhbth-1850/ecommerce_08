class SuggestionsController < ApplicationController
  include SuggestionsHelper

  authorize_resource
  before_action :load_suggestion, only: %i(edit update destroy)

  def index
    is_approve = load_value_filter params[:filter].to_i
    @suggestions = Suggestion.approve(is_approve)
                             .sort_approve
                             .paginate page: params[:page]
  end

  def new
    @suggestion = current_user.suggestions.build
  end

  def edit
    @product = Product.new name: @suggestion.name, info: @suggestion.describe
  end

  def create
    @suggestion = current_user.suggestions.build suggestion_params
    if @suggestion.save
      flash[:success] = t "flash.create_ok", name: t("label.suggestion")
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    Product.transaction do
      @product = Product.new product_params
      @product.save!
      @suggestion.update_attribute :approved, true
    end
    flash[:success] = t "flash.create_ok", name: t("label.product")
    redirect_to :suggestions
  rescue StandardError
    render :edit
  end

  def destroy
    if @suggestion.destroy
      flash[:success] = t "flash.del_ok", name: t("label.suggestion")
    else
      flash[:danger] = t "flash.nil_object", name: t("label.suggestion")
    end
    redirect_to :suggestions
  end

  private

  def load_suggestion
    @suggestion = Suggestion.find_by id: params[:id]
    return if @suggestion
    flash[:danger] = t "flash.nil_object", name: t("label.suggestion")
    redirect_to :suggestions
  end

  def suggestion_params
    params.require(:suggestion).permit :name, :describe
  end

  def product_params
    params.require(:product).permit :name, :info, :category_id,
      :quantity, :price, :image
  end
end
