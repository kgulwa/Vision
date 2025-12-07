class AddUserUidForeignKeyToPins < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :pins, :users, column: :user_uid, primary_key: :uid
  end
end
