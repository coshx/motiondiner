class AddLatLogOpenedAtToTruck < ActiveRecord::Migration
  def change
    add_column :trucks, :lat, :string
    add_column :trucks, :long, :string
    add_column :trucks, :opened_at, :boolean
  end
end
