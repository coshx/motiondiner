class CreateOpenings < ActiveRecord::Migration
  def up
     create_table :openings do |t|
       t.float :lat
       t.float :lng
       t.references :truck
       t.datetime :opened_at
       t.datetime :closed_at

       t.timestamps
     end

    remove_column :trucks, :lat
    remove_column :trucks, :long
    remove_column :trucks, :opened_at
  end
  def down
    drop_table :openings
    add_column :trucks, :lat, :string
    add_column :trucks, :long, :string
    add_column :trucks, :opened_at
  end
end
