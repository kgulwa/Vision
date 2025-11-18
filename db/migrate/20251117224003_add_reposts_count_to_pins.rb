class AddRepostsCountToPins < ActiveRecord::Migration[8.1]
  def change
    add_column :pins, :reposts_count, :integer
  end
end
