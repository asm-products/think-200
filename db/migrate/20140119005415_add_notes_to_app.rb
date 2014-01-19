class AddNotesToApp < ActiveRecord::Migration
  def change
    add_column :apps, :notes, :text
  end
end
