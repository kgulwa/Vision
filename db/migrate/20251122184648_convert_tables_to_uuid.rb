class ConvertTablesToUuid < ActiveRecord::Migration[8.1]
  def up
    # enable uuid extension
    enable_extension "uuid-ossp" unless extension_enabled?("uuid-ossp")

    # Drop tables that currently use integer PKs / bigint FKs and will be recreated as UUID-backed.
    # We drop in dependency order to avoid FK issues.
    drop_table :saved_pins, if_exists: true
    drop_table :likes, if_exists: true
    drop_table :reposts, if_exists: true
    drop_table :comments, if_exists: true
    drop_table :pins, if_exists: true
    drop_table :collections, if_exists: true

    # Recreate pins as uuid PK
    create_table :pins, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.text    :description
      t.integer :reposts_count
      t.string  :title
      t.uuid    :user_uid, null: true
      t.timestamps
    end
    add_index :pins, :user_uid
    add_foreign_key :pins, :users, column: :user_uid, primary_key: "uid"

    # Recreate collections as uuid PK
    create_table :collections, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string   :name, null: false
      t.uuid     :user_uid
      t.timestamps
    end
    add_index :collections, :user_uid
    add_foreign_key :collections, :users, column: :user_uid, primary_key: "uid"

    # Recreate comments as uuid PK
    create_table :comments, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.text    :content
      t.uuid    :parent_id
      t.uuid    :pin_id, null: false
      t.uuid    :user_uid
      t.timestamps
    end
    add_index :comments, :pin_id
    add_foreign_key :comments, :pins, column: :pin_id
    add_foreign_key :comments, :users, column: :user_uid, primary_key: "uid"

    # Recreate likes as uuid PK
    create_table :likes, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid    :pin_id, null: false
      t.uuid    :user_uid
      t.timestamps
    end
    add_index :likes, :pin_id
    add_foreign_key :likes, :pins, column: :pin_id
    add_foreign_key :likes, :users, column: :user_uid, primary_key: "uid"

    # Recreate reposts as uuid PK
    create_table :reposts, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid    :pin_id, null: false
      t.uuid    :user_uid
      t.timestamps
    end
    add_index :reposts, :pin_id
    add_foreign_key :reposts, :pins, column: :pin_id
    add_foreign_key :reposts, :users, column: :user_uid, primary_key: "uid"

    # Recreate saved_pins as uuid PK
    create_table :saved_pins, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid    :collection_id, null: false
      t.uuid    :pin_id, null: false
      t.uuid    :user_uid
      t.timestamps
    end
    add_index :saved_pins, :collection_id
    add_index :saved_pins, :pin_id
    add_index :saved_pins, :user_uid
    add_foreign_key :saved_pins, :collections, column: :collection_id
    add_foreign_key :saved_pins, :pins, column: :pin_id
    add_foreign_key :saved_pins, :users, column: :user_uid, primary_key: "uid"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration drops and recreates tables; down is not reversible."
  end
end
