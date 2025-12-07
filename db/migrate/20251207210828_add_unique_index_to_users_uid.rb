class AddUniqueIndexToUsersUid < ActiveRecord::Migration[7.0]
  def change
    # Only add the index if it does NOT already exist
    unless index_exists?(:users, :uid, name: :index_users_on_uid)
      add_index :users, :uid, unique: true, name: :index_users_on_uid
    end
  end
end
