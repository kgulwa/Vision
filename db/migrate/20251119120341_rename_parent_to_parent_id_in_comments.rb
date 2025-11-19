class RenameParentToParentIdInComments < ActiveRecord::Migration[7.0]
  def change
    rename_column :comments, :parent, :parent_id
  end
end
