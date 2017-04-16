class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :organization
      t.belongs_to :user
      t.boolean :owner, default: false, null: false
    end

    add_index :memberships, [:organization_id, :user_id], :unique => true
  end
end
