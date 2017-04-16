class AddChoicesToFieldAccessControls < ActiveRecord::Migration
  def change
    add_column :field_access_controls, :choices, :text
  end
end
