class FixCollectionsUserReference < ActiveRecord::Migration[7.1]
  def change
    # Remove wrong foreign key + column if they exist
    if foreign_key_exists?(:collections, :users)
      remove_foreign_key :collections, :users
    end

    if column_exists?(:collections, :user_id)
      remove_column :collections, :user_id
    end

    # Add correct user_uid column
    add_column :collections, :user_uid, :uuid
    add_index :collections, :user_uid

    # Add correct foreign key to users.uid
    add_foreign_key :collections, :users, column: :user_uid, primary_key: :uid
  end
end
