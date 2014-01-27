class DropPassedFromSpecRun < ActiveRecord::Migration
  def change
    remove_column :spec_runs, :passed
  end
end
