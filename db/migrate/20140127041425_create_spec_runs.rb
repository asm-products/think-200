class CreateSpecRuns < ActiveRecord::Migration
  def change
    create_table :spec_runs do |t|
      t.text :raw_data
      t.boolean :passed
      t.integer :project_id

      t.timestamps
    end
    add_index :spec_runs, :project_id
  end
end
