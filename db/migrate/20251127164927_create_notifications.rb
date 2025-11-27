class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.uuid :user_id, null: false                         # receiver of notification
      t.uuid :actor_id, null: false                        # the one who caused it

      t.string :notifiable_type, null: false
      t.uuid :notifiable_id, null: false

      t.string :action, null: false
      t.boolean :read, default: false

      t.timestamps
    end

    
    add_foreign_key :notifications, :users, column: :user_id
    add_foreign_key :notifications, :users, column: :actor_id

    
    add_index :notifications, [:notifiable_type, :notifiable_id]
    add_index :notifications, :user_id
    add_index :notifications, :actor_id
  end
end
