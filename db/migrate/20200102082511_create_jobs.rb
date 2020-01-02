class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :salary
      t.date :deadline
      t.text :description
      t.date :last_updated
      t.string :position
      t.string :experience
      t.integer :city_id
      t.timestamps null: false
    end
    add_index :jobs, :code, unique: true
  end
end
