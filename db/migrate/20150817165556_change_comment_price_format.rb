class ChangeCommentPriceFormat < ActiveRecord::Migration
  def change
    change_column :comments, :price,  :string
  end
end
