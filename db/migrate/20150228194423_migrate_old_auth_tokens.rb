class MigrateOldAuthTokens < ActiveRecord::Migration
  def up
    User.find_each do |user|
      next unless user.authentication_token.present?

      auth_token = user.auth_tokens.build
      auth_token.token = user.authentication_token
      auth_token.save!
    end
    remove_column :users, :authentication_token
  end

  def down
    add_column :users, :authentication_token, :string
  end
end
