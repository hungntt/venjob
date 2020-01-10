class CreateSavedJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :saved_jobs do |t|
      t.references :job
      t.references :user
      t.string :type

      t.timestamps null: false
    end
    add_index :saved_jobs, %i[user_id job_id]
  end
end
