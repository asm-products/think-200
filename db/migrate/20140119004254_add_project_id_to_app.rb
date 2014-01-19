class AddProjectIdToApp < ActiveRecord::Migration
  def change
    add_column :apps, :project_id, :integer
  end
end
