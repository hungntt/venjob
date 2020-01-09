class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :job, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
