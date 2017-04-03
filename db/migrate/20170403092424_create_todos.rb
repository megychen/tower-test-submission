class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :description
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end
end
