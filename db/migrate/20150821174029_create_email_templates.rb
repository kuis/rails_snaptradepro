class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :name
      t.text :subject
      t.text :body
      t.boolean :is_active
      t.text :purpose_trigger_action

      t.timestamps
    end
  end
end
