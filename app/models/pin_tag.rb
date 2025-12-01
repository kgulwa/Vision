class PinTag < ApplicationRecord
  belongs_to :pin
  belongs_to :tagged_user, class_name: "User"
  belongs_to :tagged_by, class_name: "User"
end
