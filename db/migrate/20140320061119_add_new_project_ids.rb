class AddNewProjectIds < ActiveRecord::Migration
  def change
    Expectation.find_each do |e|
      e.project = e.requirement.project
      e.save!
    end
  end
end
