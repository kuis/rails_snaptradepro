class AddTradeConditionsToValuation < ActiveRecord::Migration
  def change
    add_column :valuations, :trade_conditions, :string
  end
end
