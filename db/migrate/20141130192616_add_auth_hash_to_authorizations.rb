class AddAuthHashToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :auth_hash, :string
  end
end
