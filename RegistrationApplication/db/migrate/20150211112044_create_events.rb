class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :tag_id
      t.integer :user_id
      t.string :name
      t.string :short_description
      t.text :description

      t.timestamps null: false
    end
  end
end
