class CreateUserInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :user_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.text :objective
      t.text :work_experiences
      t.text :educations
      t.text :skills
      t.text :interests

      t.timestamps
    end
  end
end
