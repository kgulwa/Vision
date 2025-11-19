class ChangeUserIdToUserUidInFollows < ActiveRecord::Migration[7.1]
  def change
    # Remove old integer IDs
    remove_column :follows, :follower_id
    remove_column :follows, :followed_id

    # Add new UUID columns
    add_column :follows, :follower_uid, :uuid
    add_column :follows, :followed_uid, :uuid

    # Add foreign keys to users.uid
    add_foreign_key :follows, :users, column: :follower_uid, primary_key: :uid
    add_foreign_key :follows, :users, column: :followed_uid, primary_key: :uid

    # Add indexes
    add_index :follows, :follower_uid
    add_index :follows, :followed_uid
  end
end

