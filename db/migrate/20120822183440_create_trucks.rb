class CreateTrucks < ActiveRecord::Migration
  def change
    create_table :trucks do |t|
      t.string :name
      t.boolean :open

      t.timestamps
    end
  end
end
