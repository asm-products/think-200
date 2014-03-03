class AddPlaceholderToMatcher < ActiveRecord::Migration
  def change
    add_column :matchers, :placeholder, :string
  end
end
