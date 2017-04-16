class AddTermGuidelinesToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :term_guidelines, :text
  end
end
