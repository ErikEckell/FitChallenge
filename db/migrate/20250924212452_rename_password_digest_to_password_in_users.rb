class RenamePasswordDigestToPasswordInUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :password_digest, :password
  end
end
