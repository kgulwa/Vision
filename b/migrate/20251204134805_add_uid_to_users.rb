class AddUidToUsers < ActiveRecord::Migration[8.1]
  def change
    # Add UID column with random UUID generator
    add_column :users, :uid, :uuid, default: "gen_random_uuid()", null: false

    # Make sure no two users can have the same UID
    add_index :users, :uid, unique: true
  end
end
