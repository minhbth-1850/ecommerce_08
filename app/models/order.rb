class Order < ApplicationRecord
  enum state: {processing: 0, failed: 1, completed: 2, cancelled: 3}
  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products
end
