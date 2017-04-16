class AddHasEffectOnOtherFieldsAndEditableByUserToTemplateFields < ActiveRecord::Migration
  def change
    add_column :template_fields, :has_effect_on_other_fields, :boolean, :default => false
    add_column :template_fields, :editable_by_user, :boolean, :default => true
  end
end
