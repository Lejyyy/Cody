class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :stack
      t.text :content
      t.text :system_prompt
      t.string :level_project

      t.timestamps
    end
  end
end
