class ChangeUserIdToUserUidInPins < ActiveRecord::Migration[8.0]
  def change
    remove_reference :pins, :user, foreign_key: true
    add_reference :pins, :user, type: :uuid, foreign_key: true
  end
end
