class ChangeCommentPrimaryKeyToUid < ActiveRecord::Migration[8.0]
  def change
    # 1. Add a new UUID column
    add_column :comments, :uid, :uuid, default: -> { "uuid_generate_v4()" }, null: false

    # 2. Remove the old id column
    remove_column :comments, :id

    # 3. Set uid as the primary key
    execute "ALTER TABLE comments ADD PRIMARY KEY (uid);"
  end
end
