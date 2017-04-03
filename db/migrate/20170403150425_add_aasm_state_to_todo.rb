class AddAasmStateToTodo < ActiveRecord::Migration[5.0]
  def change
    add_column :todos, :aasm_state, :string, default: "created"
    add_index  :todos, :aasm_state
  end
end
