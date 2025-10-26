class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def change
    ## Remove old password column
    remove_column :users, :password, :string

    ## Database authenticatable
    add_column :users, :encrypted_password, :string, null: false, default: ""

    ## Recoverable
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :users, :remember_created_at, :datetime

    ## Indexes
    add_index :users, :reset_password_token, unique: true
  end
end
