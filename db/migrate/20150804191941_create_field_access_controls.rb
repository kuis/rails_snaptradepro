class CreateFieldAccessControls < ActiveRecord::Migration
  def change
      create_table :field_access_controls do |t|
          t.belongs_to :organization
          t.belongs_to :template_field
          t.boolean :view, default: true, null: false
          t.boolean :edit, default: true, null: false
      end
      add_index :field_access_controls, [:organization_id, :template_field_id], :unique => true, :name => 'field_access_control_index'
  end
end
