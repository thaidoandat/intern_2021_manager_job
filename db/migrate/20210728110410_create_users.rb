class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.string :address
      t.string :phone_number
      t.integer :gender
      t.date :birthday

      t.timestamps
    end
  end
end
