class ChangeUserIdToUserUidInReposts < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:reposts)
    remove_column :reposts, :user_id, if_exists: true
    add_column :reposts, :user_uid, :uuid
    add_foreign_key :reposts, :users, column: :user_uid, primary_key: :uid
  end
end
