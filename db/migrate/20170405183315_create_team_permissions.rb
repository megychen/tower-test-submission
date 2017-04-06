class CreateTeamPermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :team_permissions do |t|
      t.integer :user_id
      t.integer :team_id
      t.string :permission

      t.timestamps
    end
  end
end
