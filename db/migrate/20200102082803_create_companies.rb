class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :address
      t.text :description
      t.integer :city_id

      t.timestamps null: false
    end
  end
end
