class ChangeUserIdToUserUidInPins < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:pins)
    remove_column :pins, :user_id, if_exists: true
    add_column :pins, :user_uid, :uuid
    add_foreign_key :pins, :users, column: :user_uid, primary_key: :uid
  end
end
