class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true
      t.string :file_name
      t.string :file_url
      t.string :file_size
      t.string :file_type
      t.integer :uploaded_by

      t.timestamps
    end
  end
end
