class AddRevealedAtAndRevealedByToComments < ActiveRecord::Migration
  def change
    add_column :comments, :revealed_at, :datetime
    add_column :comments, :revealed_by, :integer

    add_index :comments, :revealed_at
  end
end
