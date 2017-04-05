class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.integer :todo_id
      t.datetime :deadline

      t.timestamps
    end
  end
end
