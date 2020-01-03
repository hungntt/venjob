class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :code
      t.string :name, null: false
      t.string :salary
      t.date :deadline
      t.text :description
      t.text :requirement
      t.date :last_updated
      t.string :position
      t.string :experience
      t.integer :city_id
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
