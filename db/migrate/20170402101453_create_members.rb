class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.integer :team_id
      t.integer :user_id
      t.timestamps
    end
  end
end
