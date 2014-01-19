class AddNotesToRequirement < ActiveRecord::Migration
  def change
    add_column :requirements, :notes, :text
  end
end
