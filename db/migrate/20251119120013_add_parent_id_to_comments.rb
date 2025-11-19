class AddParentIdToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :parent, :uuid
    add_index :comments, :parent
  end
end
