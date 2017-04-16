class CreatePrintTemplateBlocks < ActiveRecord::Migration
  def change
    create_table :print_template_blocks do |t|
      t.belongs_to :print_template
      t.integer :page
      t.string :section
      t.references :blockable, polymorphic: true, index: true
      t.json :properties

      t.timestamps
    end
  end
end
