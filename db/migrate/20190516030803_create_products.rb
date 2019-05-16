class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :info
      t.string :image
      t.integer :price, default: 0
      t.float :rank, default: 0
      t.integer :quantity, default: 0
      t.references :category, forgein_key: true, allow_nil: true

      t.timestamps
    end
  end
end
