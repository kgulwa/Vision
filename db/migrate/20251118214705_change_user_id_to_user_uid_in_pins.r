class ChangeUserIdToUserUidInPins < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :pins, :users
    remove_column :pins, :user_id
    add_reference :pins, :user, type: :uuid, foreign_key: true
  end
end