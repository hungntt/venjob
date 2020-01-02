class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :region
      t.timestamps null: false
    end
  end
end
