class AddEmailToTeamPermission < ActiveRecord::Migration[5.0]
  def change
    add_column :team_permissions, :email, :string
  end
end
