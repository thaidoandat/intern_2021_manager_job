class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.string :address
      t.string :phone_number
      t.text :description

      t.timestamps
    end
  end
end
