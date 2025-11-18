class ChangeUserIdToUserUidInReposts < ActiveRecord::Migration[8.0]
  def change
    remove_reference :reposts, :user, foreign_key: true
    add_reference :reposts, :user, type: :uuid, foreign_key: true
  end
end
