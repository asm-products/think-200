class CreateMatchers < ActiveRecord::Migration
  def change
    create_table :matchers do |t|
      t.string  :code,     null: false
      t.integer :min_args, null: false
      t.integer :max_args, null: false

      t.timestamps
    end
  end
end
