class CreateValuationUrls < ActiveRecord::Migration
  def change
    create_table :valuation_urls do |t|
      t.references :appraisal
      t.references :user
      t.string :url
      t.string :year
      t.string :make
      t.string :model
      t.float :retail_value
      t.float :wholesale_value

      t.timestamps
    end
  end
end
