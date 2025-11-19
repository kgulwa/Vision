class ChangeUserIdToUserUidInPins < ActiveRecord::Migration[7.1]
  def change
    # Remove old column
    remove_column :pins, :user_id

    # Add new UUID FK column
    add_column :pins, :user_uid, :uuid

    # Add proper FK referencing users.uid
    add_foreign_key :pins, :users, column: :user_uid, primary_key: :uid

    # Add index for speed
    add_index :pins, :user_uid
  end
end

