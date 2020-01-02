class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :address
      t.string :phone_number
      t.string :website
      t.text :description
      t.integer :size

      t.timestamps null: false
    end
  end
end
