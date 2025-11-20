class ChangeUserIdToUserUidInFollows < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:follows)
    remove_column :follows, :follower_id, if_exists: true
    remove_column :follows, :followed_id, if_exists: true
    add_column :follows, :follower_uid, :uuid
    add_column :follows, :followed_uid, :uuid
    add_foreign_key :follows, :users, column: :follower_uid, primary_key: :uid
    add_foreign_key :follows, :users, column: :followed_uid, primary_key: :uid
  end
end
