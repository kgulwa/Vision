class FixActiveStorageRecordIdForUsers < ActiveRecord::Migration[8.0]
  def change
    
    add_column :active_storage_attachments, :record_id_uuid, :uuid

    
    execute <<~SQL
      UPDATE active_storage_attachments
      SET record_id_uuid = users.id
      FROM users
      WHERE active_storage_attachments.record_type = 'User'
        AND active_storage_attachments.record_id::text = users.id::text;
    SQL

   
    execute <<~SQL
      DELETE FROM active_storage_attachments
      WHERE record_type = 'User'
        AND record_id_uuid IS NULL;
    SQL

    
    remove_column :active_storage_attachments, :record_id

   
    rename_column :active_storage_attachments, :record_id_uuid, :record_id
  end
end
