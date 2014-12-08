class ChangeAuthHashColumnOnAuthorizations < ActiveRecord::Migration
  def change
    change_column :authorizations, :auth_hash, :text, limit: nil
  end
end
