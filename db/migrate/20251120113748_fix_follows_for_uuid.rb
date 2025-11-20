class FixFollowsForUuid < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    # Drop the follows table
    drop_table :follows, if_exists: true

    # Recreate it with UUIDs
    create_table :follows do |t|
      t.uuid :follower_uid, null: false
      t.uuid :followed_uid, null: false
      t.timestamps
    end

    # Add foreign keys
    add_foreign_key :follows, :users, column: :follower_uid, primary_key: :uid
    add_foreign_key :follows, :users, column: :followed_uid, primary_key: :uid
  end
end
