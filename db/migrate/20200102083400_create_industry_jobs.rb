class CreateIndustryJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :industry_jobs do |t|
      t.references :industry, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true

      t.timestamps
    end
    add_index :industry_jobs, %i[job_id industry_id]
  end
end
