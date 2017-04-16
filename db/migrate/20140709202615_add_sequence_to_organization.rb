class AddSequenceToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :appraisal_sequence, :integer, default: 0
    add_column :organizations, :acronym, :string
  end
end
