class OrderProduct < ApplicationRecord
  belongs_to :order
  has_many :products

  scope :trend_product, -> do
    group(:product_id)
    .order("SUM(quantity) DESC")
    .select("product_id, SUM(quantity) AS total")
    .limit(Settings.products.hot_page)
  end
end
