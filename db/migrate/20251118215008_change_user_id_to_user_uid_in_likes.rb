class ChangeUserIdToUserUidInLikes < ActiveRecord::Migration[7.1]
  def change
    # Remove old user_id column
    remove_column :likes, :user_id

    # Add new UUID user reference
    add_column :likes, :user_uid, :uuid

    # Add proper FK to users.uid
    add_foreign_key :likes, :users, column: :user_uid, primary_key: :uid

    # Add index for speed
    add_index :likes, :user_uid
  end
end

