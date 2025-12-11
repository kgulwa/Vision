class CreateVideoViews < ActiveRecord::Migration[7.0]
  def change
    create_table :video_views do |t|
      t.string :user_uid            # viewer UUID
      t.uuid :pin_id                # video UUID

      t.datetime :started_at
      t.datetime :ended_at
      t.integer :duration_seconds

      t.timestamps
    end

    add_index :video_views, :user_uid
    add_index :video_views, :pin_id
  end
end
