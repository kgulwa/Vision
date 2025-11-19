class ChangeUserPrimaryKeyToUid < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :uid, :uuid, default: -> { "uuid_generate_v4()" }, null: false
    execute "ALTER TABLE users DROP CONSTRAINT users_pkey CASCADE;"
    execute "ALTER TABLE users ADD PRIMARY KEY (uid);"
  end
end

