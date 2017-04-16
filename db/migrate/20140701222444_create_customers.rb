class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :account_name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :business_phone
      t.string :direct_phone
      t.string :street_address
      t.string :city
      t.string :state_or_provence
      t.string :postal_code
      t.string :mobile_phone

      t.belongs_to :organization
    end
  end
end
