class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.integer :quantity
      t.bigint :salary
      t.text :description
      t.text :requirement
      t.text :benefit
      t.integer :status, default: 0
      t.datetime :expire_at

      t.timestamps
    end
  end
end
