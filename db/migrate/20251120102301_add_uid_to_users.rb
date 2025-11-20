class AddUidToUsers < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:users)
    # Skip if uid already exists
    return if column_exists?(:users, :uid)
    add_column :users, :uid, :uuid, default: -> { "uuid_generate_v4()" }, null: false
    add_index :users, :uid, unique: true
    User.reset_column_information
    User.where(uid: nil).each { |u| u.update!(uid: SecureRandom.uuid) }
  end
end
