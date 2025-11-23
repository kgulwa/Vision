class FixUsersAndFollowsToUuid < ActiveRecord::Migration[8.1]
  def change
    # ---- USERS TABLE FIX ----
    # Remove legacy bigint id column
    if column_exists?(:users, :id)
      remove_column :users, :id
    end

    # Remove stray 'string' column if it exists
    if column_exists?(:users, :string)
      remove_column :users, :string
    end

    # Ensure uid is the primary key
    execute "ALTER TABLE users ADD PRIMARY KEY (uid);" rescue nil

    # ---- FOLLOWS TABLE FIX ----
    # Drop & recreate follows table using uuid as id
    drop_table :follows, if_exists: true

    create_table :follows, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid :follower_uid, null: false
      t.uuid :followed_uid, null: false
      t.timestamps
    end

    add_foreign_key :follows, :users, column: :follower_uid, primary_key: "uid"
    add_foreign_key :follows, :users, column: :followed_uid, primary_key: "uid"
    add_index :follows, :follower_uid
    add_index :follows, :followed_uid
  end
end
