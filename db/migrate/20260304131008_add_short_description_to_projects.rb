class AddShortDescriptionToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :short_description, :string
  end
end
