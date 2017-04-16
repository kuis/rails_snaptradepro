class AddPlanFieldsToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :plan_name, :string
    add_column :organizations, :plan_comments, :text
    add_column :organizations, :plan_pricing, :string
  end
end
