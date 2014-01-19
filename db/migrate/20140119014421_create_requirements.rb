class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :name
      t.integer :app_id

      t.timestamps
    end
  end
end
