class BackToTradeCondition < ActiveRecord::Migration
  def change
    rename_column :valuations, :trade_cond , :trade_conditions
  end
end
