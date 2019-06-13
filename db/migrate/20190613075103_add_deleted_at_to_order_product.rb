class AddDeletedAtToOrderProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :order_products, :deleted_at, :datetime
    add_index :order_products, :deleted_at
  end
end
