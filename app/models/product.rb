class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :order_products, dependent: :destroy
end
