class CreateDeletedTweets < ActiveRecord::Migration
  def self.up
    create_table :deleted_tweets, :id => false do |t|
      t.column :id, 'bigint(19) PRIMARY KEY'
      t.integer :user_id
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :deleted_tweets
  end
end
