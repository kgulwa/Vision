class BackfillUserUids < ActiveRecord::Migration[7.0]
  def up
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:uid, SecureRandom.uuid)
    end
  end

  def down
    
  end
end
