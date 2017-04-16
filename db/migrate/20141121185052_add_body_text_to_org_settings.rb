class AddBodyTextToOrgSettings < ActiveRecord::Migration
  def change
    add_column :settings, :body_text_color, :string, default: "#000"
  end
end
