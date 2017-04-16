class AddInternalTradePolicyToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :internal_trade_policy, :text
  end
end
