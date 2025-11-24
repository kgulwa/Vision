class ApplicationRecord < ActiveRecord::Base
  self.primary_key = :uid
  primary_abstract_class

  def to_param
    uid
  end
  
end
