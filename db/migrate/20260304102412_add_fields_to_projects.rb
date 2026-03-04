class AddFieldsToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :short_description, :text
    add_column :projects, :category, :string
    add_column :projects, :duration, :string
  end
end
