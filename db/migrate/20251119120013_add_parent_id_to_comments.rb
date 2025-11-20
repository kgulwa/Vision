class AddParentIdToComments < ActiveRecord::Migration[7.0]
  def change
    return unless table_exists?(:comments)
    add_column :comments, :parent_id, :uuid
  end
end
