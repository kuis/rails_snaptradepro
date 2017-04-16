class AddUserColumns < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :street_address, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :postal_code, :string
    add_column :users, :business_phone, :string
    add_column :users, :mobile_phone, :string

    User.all.each do |user|
      user.first_name = user.name
      user.save
    end

    remove_column :users, :name, :string
  end
end
