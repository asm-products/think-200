class AddTestedAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :tested_at, :datetime
  end
end
