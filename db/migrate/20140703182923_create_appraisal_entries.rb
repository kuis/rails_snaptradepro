class CreateAppraisalEntries < ActiveRecord::Migration
  def change
    create_table :appraisal_entries do |t|
      t.text :value
      t.belongs_to :appraisal, index: true
      t.belongs_to :template_field, index: true

      t.timestamps
    end
  end
end
