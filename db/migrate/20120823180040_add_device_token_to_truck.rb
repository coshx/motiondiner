class AddDeviceTokenToTruck < ActiveRecord::Migration
  def change
    add_column :trucks, :device_token, :string
  end
end
