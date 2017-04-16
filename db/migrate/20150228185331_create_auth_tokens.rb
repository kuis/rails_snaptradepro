class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.belongs_to :user
      t.text :token
      t.timestamps
    end

    add_index :auth_tokens, :token, unique: true
  end
end
