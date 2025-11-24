class FinalizeUuidPkConversion < ActiveRecord::Migration[8.1]
  def up
    # === STEP 1: Drop old PRIMARY KEYS based on uid ===
    %i[
      users pins collections comments likes reposts follows saved_pins
    ].each do |table|
      execute "ALTER TABLE #{table} DROP CONSTRAINT IF EXISTS #{table}_pkey CASCADE;"
    end

    # === STEP 2: Promote id to PRIMARY KEY ===
    %i[
      users pins collections comments likes reposts follows saved_pins
    ].each do |table|
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
    end

    # === STEP 3: Add *_id foreign key columns if missing ===
    add_column :pins, :user_id, :uuid unless column_exists?(:pins, :user_id)
    add_column :collections, :user_id, :uuid unless column_exists?(:collections, :user_id)

    add_column :comments, :pin_id, :uuid unless column_exists?(:comments, :pin_id)
    add_column :comments, :user_id, :uuid unless column_exists?(:comments, :user_id)
    add_column :comments, :parent_id, :uuid unless column_exists?(:comments, :parent_id)

    add_column :likes, :pin_id, :uuid unless column_exists?(:likes, :pin_id)
    add_column :likes, :user_id, :uuid unless column_exists?(:likes, :user_id)

    add_column :reposts, :pin_id, :uuid unless column_exists?(:reposts, :pin_id)
    add_column :reposts, :user_id, :uuid unless column_exists?(:reposts, :user_id)

    add_column :follows, :follower_id, :uuid unless column_exists?(:follows, :follower_id)
    add_column :follows, :followed_id, :uuid unless column_exists?(:follows, :followed_id)

    add_column :saved_pins, :collection_id, :uuid unless column_exists?(:saved_pins, :collection_id)
    add_column :saved_pins, :pin_id, :uuid unless column_exists?(:saved_pins, :pin_id)
    add_column :saved_pins, :user_id, :uuid unless column_exists?(:saved_pins, :user_id)

    # === STEP 4: Copy old uid references ===
    execute "UPDATE pins SET user_id = user_uid;"
    execute "UPDATE collections SET user_id = user_uid;"

    execute "UPDATE comments SET pin_id = pin_uid;"
    execute "UPDATE comments SET user_id = user_uid;"
    execute "UPDATE comments SET parent_id = parent_uid WHERE parent_uid IS NOT NULL;"

    execute "UPDATE likes SET pin_id = pin_uid;"
    execute "UPDATE likes SET user_id = user_uid;"

    execute "UPDATE reposts SET pin_id = pin_uid;"
    execute "UPDATE reposts SET user_id = user_uid;"

    execute "UPDATE follows SET follower_id = follower_uid;"
    execute "UPDATE follows SET followed_id = followed_uid;"

    execute "UPDATE saved_pins SET collection_id = collection_uid;"
    execute "UPDATE saved_pins SET pin_id = pin_uid;"
    execute "UPDATE saved_pins SET user_id = user_uid;"

    # === STEP 5: Add foreign key constraints for new *_id columns ===
    add_foreign_key :pins, :users, column: :user_id
    add_foreign_key :collections, :users, column: :user_id

    add_foreign_key :comments, :pins, column: :pin_id
    add_foreign_key :comments, :users, column: :user_id
    add_foreign_key :comments, :comments, column: :parent_id

    add_foreign_key :likes, :pins, column: :pin_id
    add_foreign_key :likes, :users, column: :user_id

    add_foreign_key :reposts, :pins, column: :pin_id
    add_foreign_key :reposts, :users, column: :user_id

    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followed_id

    add_foreign_key :saved_pins, :collections, column: :collection_id
    add_foreign_key :saved_pins, :pins, column: :pin_id
    add_foreign_key :saved_pins, :users, column: :user_id

    # === STEP 6: Drop old *_uid columns ===
    remove_column :pins, :user_uid
    remove_column :collections, :user_uid

    remove_column :comments, :pin_uid
    remove_column :comments, :user_uid
    remove_column :comments, :parent_uid

    remove_column :likes, :pin_uid
    remove_column :likes, :user_uid

    remove_column :reposts, :pin_uid
    remove_column :reposts, :user_uid

    remove_column :follows, :follower_uid
    remove_column :follows, :followed_uid

    remove_column :saved_pins, :collection_uid
    remove_column :saved_pins, :pin_uid
    remove_column :saved_pins, :user_uid

    # === STEP 7: Drop uid primary key columns ===
    %i[
      users pins collections comments likes reposts follows saved_pins
    ].each do |table|
      remove_column table, :uid if column_exists?(table, :uid)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
