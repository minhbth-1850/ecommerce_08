module ProductsHelper
  include ActionView::Helpers::NumberHelper
  SORT_OPTION = {created_at: 0, price: 1, rank: 2}.freeze
  STAR_RANGE = [5, 4, 3, 2, 1].freeze

  def load_options
    SORT_OPTION.map{|k, v| [I18n.t("sort_option")[k], v]}
  end

  def load_categories
    Category.activates.map{|x| [x.name, x.id]}
  end

  def load_range_rate
    STAR_RANGE.map{|n| [n, n]}
  end

  def load_all_products per_page
    Product.activates
           .order_option(:created_at)
           .includes(:category)
           .paginate(page: params[:page], per_page: per_page)
  end

  def load_params_option sort_id
    option = SORT_OPTION.key(sort_id)
    option || SORT_OPTION.frist[0]
  end

  def select_products category_id, sort_id, per_page
    option = load_params_option(sort_id.to_i)
    ids = load_category_chilrens(category_id)
    Product.includes(:category)
           .activates
           .load_category(ids)
           .order_option(option)
           .paginate(page: params[:page], per_page: per_page)
  end

  def load_trend_products
    trends = OrderProduct.trend_product
    list_ids = trends.map(&:product_id)
    Product.activates.find_ids(list_ids)
  end

  def load_category_chilrens id
    parent_ids = []
    return parent_ids if id.blank?

    id = id.to_i
    parent_ids << id
    @categories = Category.all
    while id.present?
      @categories.each do |cat|
        next if id != cat.parent_id
        parent_ids << cat.id
        id = cat.id
      end
      id = nil
    end
    parent_ids
  end

  def number_to_price price
    number_to_currency price, unit: I18n.t("product.unit")
  end

  def fake_sale_price price
    number_to_price price * Settings.products.fake_sale
  end
end
