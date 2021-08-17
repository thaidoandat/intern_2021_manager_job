class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.integer :noti_type

      t.timestamps
    end

    add_column :notifications, :status, :int, default: 0
  end
end
