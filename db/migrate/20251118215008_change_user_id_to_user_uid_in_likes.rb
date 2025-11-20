class ChangeUserIdToUserUidInLikes < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:likes)
    remove_column :likes, :user_id, if_exists: true
    add_column :likes, :user_uid, :uuid
    add_foreign_key :likes, :users, column: :user_uid, primary_key: :uid
  end
end
