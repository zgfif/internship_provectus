class AddUserDataColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :token, :string
    add_column :users, :refresh_token, :string
    add_column :users, :expires_at, :datetime
  end
end
