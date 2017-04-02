class AddUserIdToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :user_id, :integer
  end
end
