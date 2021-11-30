class RemovePictureToTweets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweets, :picture, :string
  end
end
