class ChangeUserIdToUserUidInReposts < ActiveRecord::Migration[7.1]
  def change
    # Remove old user_id column
    remove_column :reposts, :user_id

    # Add new UUID user reference
    add_column :reposts, :user_uid, :uuid

    # Add FK referencing users.uid
    add_foreign_key :reposts, :users, column: :user_uid, primary_key: :uid

    # Add index
    add_index :reposts, :user_uid
  end
end

