class AddActiveToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :activated, :boolean, default: true
  end
end
