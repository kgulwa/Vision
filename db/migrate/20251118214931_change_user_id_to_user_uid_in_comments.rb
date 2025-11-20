class ChangeUserIdToUserUidInComments < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:comments)
    remove_column :comments, :user_id, if_exists: true
    add_column :comments, :user_uid, :uuid
    add_foreign_key :comments, :users, column: :user_uid, primary_key: :uid
  end
end
