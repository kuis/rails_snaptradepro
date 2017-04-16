class AddNameToAppraisals < ActiveRecord::Migration
  def change
    add_column :appraisals, :name, :string
  end
end
