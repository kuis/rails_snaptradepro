class ChangeTradeCondFieldType < ActiveRecord::Migration
  def change
    change_column :valuations, :trade_conditions, :text, limit: 300
  end
end
