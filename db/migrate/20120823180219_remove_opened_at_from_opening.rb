class RemoveOpenedAtFromOpening < ActiveRecord::Migration
  def up
     remove_column :openings, :opened_at
  end

  def down
    add_column :openings, :opened_at, :datetime
  end
end
