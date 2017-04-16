class CreateValuations < ActiveRecord::Migration
  def change
    create_table :valuations do |t|
      ['Requested Value', 'Approved Value', 'Estimated Reconditioning', 'Approved Reconditioning', 
       'Proposed Retail', 'Approved Retail', 'Approved Good Until Date', 'Expected Acquisition Date'].each do |label|
        t.string label.downcase.tr(" ", "_")
      end
      t.references :appraisal
    end
  end
end
