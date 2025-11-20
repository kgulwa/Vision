class ChangeCommentPrimaryKeyToUid < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    return unless table_exists?(:comments)
    remove_column :comments, :id, if_exists: true
    add_column :comments, :id, :uuid, primary_key: true, default: -> { "uuid_generate_v4()" }
  end
end
