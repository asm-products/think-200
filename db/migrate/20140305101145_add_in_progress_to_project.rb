class AddInProgressToProject < ActiveRecord::Migration
  def change
    add_column :projects, :in_progress, :boolean
  end
end
