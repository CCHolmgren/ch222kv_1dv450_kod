class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.decimal :longitude
      t.decimal :latitude

      t.timestamps null: false
    end
  end
end
