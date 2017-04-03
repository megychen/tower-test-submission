class AddTeamOwnerToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :team_owner, :boolean, default: false
  end
end
