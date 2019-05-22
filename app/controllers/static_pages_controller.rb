class StaticPagesController < ApplicationController
  def home
    @products = load_all_products Settings.products.per_page
    @trend_products = load_trend_products
  end

  def select
    @trend_products = []
    @products = select_products(params[:category_id], params[:sort_id],
      Settings.products.per_page)
    render :home
  end
end
