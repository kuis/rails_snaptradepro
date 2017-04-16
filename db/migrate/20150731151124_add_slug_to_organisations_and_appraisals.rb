class AddSlugToOrganisationsAndAppraisals < ActiveRecord::Migration
  def change
    add_column :organizations, :slug, :string
    add_column :appraisals, :slug, :string

    add_index :organizations, :slug
    add_index :appraisals, :slug
  end
end
