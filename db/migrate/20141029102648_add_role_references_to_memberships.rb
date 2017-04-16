class AddRoleReferencesToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :role_id, :integer
    add_column :memberships, :job_title, :string
  end
end
