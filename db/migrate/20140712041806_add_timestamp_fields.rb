class AddTimestampFields < ActiveRecord::Migration
  def change
    add_column(:customers, :created_at, :datetime)
    add_column(:customers, :updated_at, :datetime)
    add_column(:organizations, :created_at, :datetime)
    add_column(:organizations, :updated_at, :datetime)
  end
end
