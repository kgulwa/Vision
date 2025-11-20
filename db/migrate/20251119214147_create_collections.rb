class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.timestamps
    end
  end
end
