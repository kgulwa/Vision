class CreateReposts < ActiveRecord::Migration[8.1]
  def change
    create_table :reposts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pin, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :reposts, [:user_id, :pin_id], unique: true
  end
end