class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :todo_id
      t.string :action
      t.string :string
    end
    add_index :events, [:user_id]
    add_index :events, [:project_id]
    add_index :events, [:todo_id]
  end
end
