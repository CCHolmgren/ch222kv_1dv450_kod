class CreateApiApplications < ActiveRecord::Migration
  def change
    create_table :api_applications do |t|
      t.string :name
      t.text :description
      t.string :client_key
      t.string :client_secret
      t.string :url

      t.timestamps null: false
    end
  end
end
