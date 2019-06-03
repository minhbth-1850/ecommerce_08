class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products

  validates :name, presence: true,
    length: {maximum: Settings.products.name_length}
  validates :info, presence: true
  validates :quantity,
    numericality: {greater_than_or_equal_to: 0, only_integer: true}
  validates :price,
    numericality: {greater_than_or_equal_to: 0, only_integer: true}

  mount_uploader :image, PictureUploader

  scope :order_option, ->(option){order(option => :DESC)}
  scope :load_category, ->(ids){where category_id: ids if ids.any?}
  scope :find_ids, ->(ids){where id: ids}
  scope :activates, ->{where activated: true}

  attr_accessor :amount_added

  class << self
    def import file_path
      counter = 0
      CSV.foreach(file_path, headers: true) do |row|
        product = row.to_hash
        product.delete("id")
        counter += 1 if Product.create(product)
      end
      counter
    end

    def to_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end

    def to_template
      column_names = %w(id name info category_id quantity price)
      product = Product.new Settings.products.default.to_hash
      CSV.generate do |csv|
        csv << column_names
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

  def get_rank
    (rank * 2).round / 2.0
  end

  def get_total_price
    amount_added.present? ? price * amount_added : price
  end
end
