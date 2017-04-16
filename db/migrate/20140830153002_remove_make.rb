class RemoveMake < ActiveRecord::Migration
  def change
    remove_column :appraisals, :make, :string
  end
end
