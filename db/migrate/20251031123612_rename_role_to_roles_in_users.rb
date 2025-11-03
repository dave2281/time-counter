class RenameRoleToRolesInUsers < ActiveRecord::Migration[8.0]
  def change
    # Rename role to roles if role column exists
    if column_exists?(:users, :role) && !column_exists?(:users, :roles)
      rename_column :users, :role, :roles
    end
  end
end
