class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.references :checklist
      t.string :description
      t.boolean :completed, default: false
      t.integer :creator_id
      t.integer :owner_id

      t.timestamps
    end
  end
end
