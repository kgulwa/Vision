class RemovePinUidConstraints < ActiveRecord::Migration[8.1]
  def up
    say "Removing FK constraints that reference pins(uid)"

    # COMMENTS.pin_uid
    if foreign_key_exists?(:comments, :pins, column: :pin_uid)
      remove_foreign_key :comments, column: :pin_uid
      say "Removed FK fk_rails_72f443c8a3 from comments"
    end

    # LIKES.pin_uid
    if foreign_key_exists?(:likes, :pins, column: :pin_uid)
      remove_foreign_key :likes, column: :pin_uid
      say "Removed FK fk_rails_f039c01c26 from likes"
    end

    # REPOSTS.pin_uid
    if foreign_key_exists?(:reposts, :pins, column: :pin_uid)
      remove_foreign_key :reposts, column: :pin_uid
      say "Removed FK fk_rails_a53a333861 from reposts"
    end

    # SAVED_PINS.pin_uid
    if foreign_key_exists?(:saved_pins, :pins, column: :pin_uid)
      remove_foreign_key :saved_pins, column: :pin_uid
      say "Removed FK fk_rails_c4a492064e from saved_pins"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
