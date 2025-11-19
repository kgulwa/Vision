class ChangeUserIdToUserUidInPins < ActiveRecord::Migration[7.1]
  def change
    # Remove foreign key ONLY if it exists
    if foreign_key_exists?(:pins, :users)
      remove_foreign_key :pins, :users
    end

    # Remove user_id column ONLY if it exists
    if column_exists?(:pins, :user_id)
      remove_column :pins, :user_id
    end

    # Add user_uid ONLY if it doesn't exist
    unless column_exists?(:pins, :user_uid)
      add_column :pins, :user_uid, :uuid
    end

    # Add foreign key ONLY if it doesn't exist
    unless foreign_key_exists?(:pins, :users, column: :user_uid)
      add_foreign_key :pins, :users, column: :user_uid, primary_key: :uid
    end
  end
end


