class AddPriceToComments < ActiveRecord::Migration
  def change
    add_column :comments, :price, :decimal
  end
end
