class ChangeUserIdToUserUidInLikes < ActiveRecord::Migration[8.0]
  def change
    remove_reference :likes, :user, foreign_key: true
    add_reference :likes, :user, type: :uuid, foreign_key: true
  end
end
