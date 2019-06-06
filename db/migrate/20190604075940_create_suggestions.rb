class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :describe
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
