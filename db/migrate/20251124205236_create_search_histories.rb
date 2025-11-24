class CreateSearchHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :search_histories, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :query

      t.timestamps
    end

    add_foreign_key :search_histories, :users, column: :user_id, primary_key: :id
    add_index :search_histories, :user_id
  end
end
