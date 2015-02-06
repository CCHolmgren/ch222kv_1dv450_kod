class AddUserIdToApiApplications < ActiveRecord::Migration
  def change
    add_column :api_applications, :user_id, :integer
  end
end
