class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.bigint :parent_id

      t.timestamps
    end
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
