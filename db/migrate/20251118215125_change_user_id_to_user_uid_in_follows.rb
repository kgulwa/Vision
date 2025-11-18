class ChangeUserIdToUserUidInFollows < ActiveRecord::Migration[8.0]
  def change
    remove_reference :follows, :follower, foreign_key: true
    add_reference :follows, :follower, type: :uuid, foreign_key: true
    remove_reference :follows, :followed, foreign_key: true
    add_reference :follows, :followed, type: :uuid, foreign_key: true
  end
end
