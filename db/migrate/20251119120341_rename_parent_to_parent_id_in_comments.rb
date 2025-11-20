class RenameParentToParentIdInComments < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:comments) && column_exists?(:comments, :parent)
    rename_column :comments, :parent, :parent_id
  end
end
