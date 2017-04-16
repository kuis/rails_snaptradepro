class CreateTemplateFields < ActiveRecord::Migration
  def change
    create_table :template_fields do |t|
      t.string :name
      t.string :field_type
      t.belongs_to :appraisal_category
      t.belongs_to :appraisal_template

      t.timestamps
    end
  end
end
