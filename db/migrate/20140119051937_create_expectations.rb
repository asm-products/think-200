class CreateExpectations < ActiveRecord::Migration
  def change
    create_table :expectations do |t|
      t.string :subject, null: false
      t.integer :matcher_id, null: false
      t.string :expectation
      t.integer :requirement_id, null: false

      t.timestamps
    end
  end
end
