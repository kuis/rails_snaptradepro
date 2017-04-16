class CreatePrintTemplates < ActiveRecord::Migration
  def change
    create_table :print_templates do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
