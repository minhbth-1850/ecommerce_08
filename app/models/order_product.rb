class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  after_create :decrement_product_quantity!

  scope :trend_product, (lambda do
    group(:product_id)
      .order("SUM(quantity) DESC")
      .select("product_id, SUM(quantity) AS total")
      .limit(Settings.products.hot_page)
  end)

  def decrement_product_quantity!
    product.decrement!(:quantity, quantity)
  end
end
