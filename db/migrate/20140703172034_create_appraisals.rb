class CreateAppraisals < ActiveRecord::Migration
  def change
    create_table :appraisals do |t|
      t.string :number
      t.string :status
      t.string :make
      t.string :unit
      t.belongs_to :user
      t.belongs_to :customer
      t.belongs_to :appraisal_template
      t.belongs_to :organization

      t.timestamps
    end
  end
end
