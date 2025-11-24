class RemoveOldPinUidFks < ActiveRecord::Migration[8.1]
  def up
    say "Removing foreign keys that point to pins.pin_uid"

    # comments.pin_uid
    if foreign_key_exists?(:comments, :pins, column: :pin_uid)
      remove_foreign_key :comments, column: :pin_uid
      say "Removed FK comments.pin_uid"
    end

    # likes.pin_uid
    if foreign_key_exists?(:likes, :pins, column: :pin_uid)
      remove_foreign_key :likes, column: :pin_uid
      say "Removed FK likes.pin_uid"
    end

    # reposts.pin_uid
    if foreign_key_exists?(:reposts, :pins, column: :pin_uid)
      remove_foreign_key :reposts, column: :pin_uid
      say "Removed FK reposts.pin_uid"
    end

    # saved_pins.pin_uid
    if foreign_key_exists?(:saved_pins, :pins, column: :pin_uid)
      remove_foreign_key :saved_pins, column: :pin_uid
      say "Removed FK saved_pins.pin_uid"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
