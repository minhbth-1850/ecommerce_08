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

  def search
    search_text = params[:search_text]
    @trend_products = []
    @products = if search_text.blank?
                  load_all_products Settings.products.per_page
                else
                  Product.search(search_text).activates
                         .paginate page: params[:page],
                           per_page: Settings.products.per_page
                end
    render :home
  end
end
