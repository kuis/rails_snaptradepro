class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :profile
      t.string :description

      t.timestamps
    end
  end
end
