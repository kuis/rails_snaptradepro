class AddCommentTextColorToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :comment_text_color, :string, default: "#000"
  end
end
