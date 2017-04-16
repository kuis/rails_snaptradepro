class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :organization
      t.string     :header_color
      t.string     :sub_header_color
      t.string     :sub_background_color
      t.string     :text_color, default: 'black'

      t.timestamps
    end
  end
end
