class Order < ApplicationRecord
  enum state: {processing: 0, failed: 1, completed: 2, cancelled: 3}
  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  validates :address, presence: true
  validates :reciever_name, presence: true
  validates :phone, presence: true, numericality: true,
    length: {minimum: Settings.users.phone_min,
             maximum: Settings.users.phone_max}
  validate :enough_product

  scope :latest, ->{order(updated_at: :DESC)}

  private

  def enough_product
    order_products.each do |placement|
      product = placement.product
      if placement.quantity > product.quantity
        errors.add(product.name, I18n.t("product.out_stock",
          count: product.quantity))
      end
    end
  end
end
