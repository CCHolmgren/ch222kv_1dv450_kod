class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :value
      t.datetime :expiry

      t.timestamps null: false
    end
  end
end
