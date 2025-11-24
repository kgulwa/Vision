class InitUidSchema < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pgcrypto"

    # USERS
    create_table :users, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.string :username
      t.string :email
      t.string :password_digest
      t.timestamps
    end
    add_index :users, :email, unique: true


    # PINS
    create_table :pins, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.string :title
      t.text :description
      t.integer :reposts_count
      t.uuid :user_uid, null: false
      t.timestamps
    end
    add_foreign_key :pins, :users, column: :user_uid, primary_key: :uid


    # COMMENTS
    create_table :comments, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.text :content
      t.uuid :parent_uid
      t.uuid :pin_uid, null: false
      t.uuid :user_uid, null: false
      t.timestamps
    end
    add_foreign_key :comments, :pins, column: :pin_uid, primary_key: :uid
    add_foreign_key :comments, :users, column: :user_uid, primary_key: :uid


    # LIKES
    create_table :likes, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.uuid :pin_uid, null: false
      t.uuid :user_uid, null: false
      t.timestamps
    end
    add_index :likes, [:user_uid, :pin_uid], unique: true
    add_foreign_key :likes, :pins, column: :pin_uid, primary_key: :uid
    add_foreign_key :likes, :users, column: :user_uid, primary_key: :uid


    # REPOSTS
    create_table :reposts, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.uuid :pin_uid, null: false
      t.uuid :user_uid, null: false
      t.timestamps
    end
    add_index :reposts, [:user_uid, :pin_uid], unique: true
    add_foreign_key :reposts, :pins, column: :pin_uid, primary_key: :uid
    add_foreign_key :reposts, :users, column: :user_uid, primary_key: :uid


    # FOLLOWS
    create_table :follows, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.uuid :follower_uid, null: false
      t.uuid :followed_uid, null: false
      t.timestamps
    end
    add_index :follows, [:follower_uid, :followed_uid], unique: true
    add_foreign_key :follows, :users, column: :follower_uid, primary_key: :uid
    add_foreign_key :follows, :users, column: :followed_uid, primary_key: :uid


    # COLLECTIONS
    create_table :collections, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.string :name, null: false
      t.uuid :user_uid, null: false
      t.timestamps
    end
    add_foreign_key :collections, :users, column: :user_uid, primary_key: :uid


    # SAVED_PINS
    create_table :saved_pins, id: false do |t|
      t.uuid :uid, primary_key: true, default: -> { "gen_random_uuid()" }
      t.uuid :collection_uid, null: false
      t.uuid :pin_uid, null: false
      t.uuid :user_uid, null: false
      t.timestamps
    end
    add_index :saved_pins, [:collection_uid, :pin_uid], unique: true
    add_foreign_key :saved_pins, :collections, column: :collection_uid, primary_key: :uid
    add_foreign_key :saved_pins, :pins, column: :pin_uid, primary_key: :uid
    add_foreign_key :saved_pins, :users, column: :user_uid, primary_key: :uid
  end
end
