class AddUniqueIndexToChats < ActiveRecord::Migration[8.1]
  def change
  add_index :chats, [:user_id, :project_id], unique: true
  end
end