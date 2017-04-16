class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name
      t.integer :creator_id
      t.references :appraisal

      t.timestamps
    end
  end
end
