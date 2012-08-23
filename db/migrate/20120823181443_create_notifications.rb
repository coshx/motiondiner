class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :truck
      t.datetime :scheduled_for
      t.timestamps
    end
  end
end
