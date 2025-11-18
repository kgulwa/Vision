class ChangeUserIdToUserUidInComments < ActiveRecord::Migration[8.0]
  def change
    remove_reference :comments, :user, foreign_key: true
    add_reference :comments, :user, type: :uuid, foreign_key: true
  end
end
