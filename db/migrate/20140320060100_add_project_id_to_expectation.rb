class AddProjectIdToExpectation < ActiveRecord::Migration
  def change
    add_column :expectations, :project_id, :integer
  end
end
