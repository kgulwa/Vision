class ChangeUserPrimaryKeyToUid < ActiveRecord::Migration[8.0]
  def change
    # 1. Add a new UUID column
    add_column :users, :uid, :uuid, default: -> { "uuid_generate_v4()" }, null: false

    # 2. Remove the old id column
    remove_column :users, :id

    # 3. Set uid as the primary key
    execute "ALTER TABLE users ADD PRIMARY KEY (uid);"
  end
end
