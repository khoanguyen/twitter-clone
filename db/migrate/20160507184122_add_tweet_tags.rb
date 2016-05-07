class AddTweetTags < ActiveRecord::Migration
  def change
    add_column :users, :tag_statistic, :string, null: true
    add_column :tweets, :tags, :string, null: true
  end
end
