class AddLabelAndPrintLabelToFieldAccessControls < ActiveRecord::Migration
  def change
    add_column :field_access_controls, :label, :string
    add_column :field_access_controls, :print_label, :string
  end
end
