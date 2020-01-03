class CreateSavedJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :saved_jobs do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :type

      t.timestamps null: false
    end
    add_index :saved_jobs, %i[user_id job_id]
  end
end
