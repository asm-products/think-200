class AddComingSoonToMatcher < ActiveRecord::Migration
  def change
    add_column :matchers, :coming_soon, :boolean
  end
end
