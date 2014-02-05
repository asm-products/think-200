class AddManualToSpecRun < ActiveRecord::Migration
  def change
    add_column :spec_runs, :manual, :boolean
  end
end
