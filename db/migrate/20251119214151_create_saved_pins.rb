class CreateSavedPins < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_pins do |t|
      t.references :pin, null: false, foreign_key: true, type: :bigint
      t.references :collection, null: false, foreign_key: true, type: :bigint
      t.timestamps
    end
  end
end
