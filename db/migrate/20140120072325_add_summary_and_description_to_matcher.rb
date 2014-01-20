class AddSummaryAndDescriptionToMatcher < ActiveRecord::Migration
  def change
    add_column :matchers, :summary, :string
    add_column :matchers, :description, :text
  end
end
