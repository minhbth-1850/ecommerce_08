class StaticPagesController < ApplicationController
  before_action :load_search_text

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
    @trend_products = []
    @products = @q.result.paginate page: params[:page],
                    per_page: Settings.products.per_page
    render :home
  end

  private

  def load_search_text
    @search_text = ""
    @search_text = params[:q][:seach_params_cont] if params[:q]
  end
end
