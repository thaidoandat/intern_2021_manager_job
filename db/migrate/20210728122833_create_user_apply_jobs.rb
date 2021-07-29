class CreateUserApplyJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :user_apply_jobs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
