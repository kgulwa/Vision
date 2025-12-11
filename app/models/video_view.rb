class VideoView < ApplicationRecord
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid
  belongs_to :pin
end
