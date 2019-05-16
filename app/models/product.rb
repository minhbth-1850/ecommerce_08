class Product < ApplicationRecord
  belongs_to :category, optional: true
  mount_uploader :image, PictureUploader

  validates :name, presence: true, length: {maximum: 50}
  validates :info, presence: true
  validates :quantity, numericality: {greater_than_or_equal_to: 0,  only_integer: true}
  validates :price, numericality: {greater_than_or_equal_to: 0,  only_integer: true}
  validate :image_size

  def get_price
    number_to_currency price, unit: "VND "
  end

  private

  def image_size
    if image.size > 5.megabytes
      errors.add(:image, "should be less than 5MB")
    end
  end
end
