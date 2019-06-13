class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  belongs_to :parent, class_name: Category.name, foreign_key: :parent_id,
    optional: true
  has_many :children, class_name: Category.name, foreign_key: :parent_id

  validates :name, presence: true
  validate :check_parent

  # paranoia solf delete
  acts_as_paranoid

  def get_parent_name
    return "null" unless parent_id
    parent.name
  end

  private

  def check_parent
    if parent_id && parent_id == id
      errors.add(I18n.t("label.category"), I18n.t("flash.parent_self"))
    end
  end
end
