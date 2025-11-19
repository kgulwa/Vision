class ChangeUserIdToUserUidInComments < ActiveRecord::Migration[7.1]
  def change
    # Remove old user_id
    remove_column :comments, :user_id

    # Add new UUID column
    add_column :comments, :user_uid, :uuid

    # Add FK referencing users.uid
    add_foreign_key :comments, :users, column: :user_uid, primary_key: :uid

    # Add index
    add_index :comments, :user_uid
  end
end

