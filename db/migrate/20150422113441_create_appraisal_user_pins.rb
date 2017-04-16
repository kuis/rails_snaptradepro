class CreateAppraisalUserPins < ActiveRecord::Migration
  def change
    create_table :appraisal_user_pins do |t|
      t.references :appraisal
      t.references :user
      t.references :appraisal_category
      t.timestamps
    end


    add_index :appraisal_user_pins, [:appraisal_id, :user_id]
  end
end
