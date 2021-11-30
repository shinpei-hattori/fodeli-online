class AddPicturesToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :pictures, :json
  end
end
