class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.integer :sent_user_id
      t.integer :received_user_id
      t.references :job, null: false, foreign_key: true

      t.timestamps null: false
    end
    add_index :requests, :sent_user_id
    add_index :requests, :received_user_id
    add_index :requests, %i[sent_user_id received_user_id], unique: true
  end
end
