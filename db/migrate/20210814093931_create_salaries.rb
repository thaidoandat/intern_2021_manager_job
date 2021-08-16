class CreateSalaries < ActiveRecord::Migration[6.1]
  def change
    create_table :salaries do |t|
      t.bigint :min_salary
      t.bigint :max_salary

      t.timestamps
    end
  end
end
