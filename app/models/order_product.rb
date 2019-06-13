class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  delegate :image, :name, :info, :price, to: :product

  after_create :decrement_product_quantity!

  scope :trend_product, (lambda do
    group(:product_id)
      .order("SUM(quantity) DESC")
      .select("product_id, SUM(quantity) AS total")
      .limit(Settings.products.hot_page)
  end)

  scope :chart_product, (lambda do
    joins(:product)
      .group(:name)
      .sum(:quantity)
  end)

  # paranoia solf delete
  acts_as_paranoid

  def decrement_product_quantity!
    product.decrement!(:quantity, quantity)
  end

  def get_total_price
    price * quantity
  end
end
