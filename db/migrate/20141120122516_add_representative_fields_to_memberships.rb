class AddRepresentativeFieldsToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :email, :string
    add_column :memberships, :contact_phone, :string
    add_attachment :memberships, :avatar
  end
end
