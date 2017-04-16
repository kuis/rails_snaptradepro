class AddEmailSuffixToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :email_suffix, :string
  end
end
