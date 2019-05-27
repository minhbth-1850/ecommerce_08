class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :placements

  scope :order_option, ->(option){order(option => :DESC)}
  scope :load_category, ->(ids){where category_id: ids if ids.any?}
  scope :find_ids, ->(ids){where id: ids}

  attr_accessor :amount_added

  def get_rank
    (rank * 2).round / 2.0
  end

  def get_total_price
    price * amount_added
  end
end
