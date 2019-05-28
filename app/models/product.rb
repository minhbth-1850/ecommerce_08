class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :placements

  validates :name, presence: true,
    length: {maximum: Settings.products.name_length}
  validates :info, presence: true
  validates :quantity,
    numericality: {greater_than_or_equal_to: 0, only_integer: true}
  validates :price,
    numericality: {greater_than_or_equal_to: 0, only_integer: true}

  scope :order_option, ->(option){order(option => :DESC)}
  scope :load_category, ->(ids){where category_id: ids if ids.any?}
  scope :find_ids, ->(ids){where id: ids}
  scope :activates, ->{where activated: true}

  attr_accessor :amount_added

  def get_rank
    (rank * 2).round / 2.0
  end

  def get_total_price
    price * amount_added
  end
end
