class ChandValuationTradeCondition < ActiveRecord::Migration
  def change
    rename_column :valuations, :trade_conditions, :trade_cond
  end
end
