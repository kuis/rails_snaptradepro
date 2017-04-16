class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string :name
      t.references :appraisal
      t.references :user

      t.timestamps
    end
  end
end
