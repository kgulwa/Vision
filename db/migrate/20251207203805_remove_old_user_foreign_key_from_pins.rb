class RemoveOldUserForeignKeyFromPins < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :pins, column: :user_id rescue nil
  end
end
