class EmailTemplate < ActiveRecord::Base
  validates :name, :uniqueness => true
end
