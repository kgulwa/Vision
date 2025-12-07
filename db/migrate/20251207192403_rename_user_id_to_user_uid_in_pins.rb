class RenameUserIdToUserUidInPins < ActiveRecord::Migration[7.0]
  def change
    rename_column :pins, :user_id, :user_uid
  end
end
