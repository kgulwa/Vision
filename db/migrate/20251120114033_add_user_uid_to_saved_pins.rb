class AddUserUidToSavedPins < ActiveRecord::Migration[7.1]
  def change
    add_column :saved_pins, :user_uid, :string
    add_index :saved_pins, :user_uid
  end
end
