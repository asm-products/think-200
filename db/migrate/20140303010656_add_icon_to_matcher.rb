class AddIconToMatcher < ActiveRecord::Migration
  def change
    add_column :matchers, :icon, :string
  end
end
