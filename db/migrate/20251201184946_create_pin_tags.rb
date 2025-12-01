class CreatePinTags < ActiveRecord::Migration[8.1]
  def change
    create_table :pin_tags, id: :uuid do |t|
      t.references :pin, type: :uuid, null: false, foreign_key: true
      t.references :tagged_user, type: :uuid, null: false, foreign_key: { to_table: :users }
      t.references :tagged_by, type: :uuid, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
