class AddHighlightLineColorToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :highlight_line_color, :string, default: "#000"
  end
end
