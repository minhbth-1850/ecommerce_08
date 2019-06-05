class AddActiveToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :activated, :boolean, default: true
  end
end
