class AddMostRecentTestToProject < ActiveRecord::Migration
  def change
    add_column :projects, :most_recent_test, :integer
  end
end
