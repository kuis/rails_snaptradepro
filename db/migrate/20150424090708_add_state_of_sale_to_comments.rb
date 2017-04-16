class AddStateOfSaleToComments < ActiveRecord::Migration
  def change
    add_column :comments, :state_of_sale, :string
  end
end
