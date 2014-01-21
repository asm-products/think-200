class ChangeExpectationColumnToExpected < ActiveRecord::Migration
  def change
    rename_column :expectations, :expectation, :expected
  end
end
