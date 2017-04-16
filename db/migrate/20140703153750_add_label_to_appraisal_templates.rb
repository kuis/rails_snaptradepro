class AddLabelToAppraisalTemplates < ActiveRecord::Migration
  def up
    add_column :appraisal_templates, :label, :string

    AppraisalTemplate.all.each do |at|
      at.label = at.name
      at.name = at.name.downcase.gsub(" ", "_")
      at.save
    end
  end

  def down
    remove_column :appraisal_templates, :label
  end
end
