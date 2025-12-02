class MakeTaggedByOptionalInPinTags < ActiveRecord::Migration[8.1]
  def change
    change_column_null :pin_tags, :tagged_by_id, true
  end
end
