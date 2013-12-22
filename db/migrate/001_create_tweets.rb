class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets, :id => false do |t|
      t.column :id, 'bigint(19) PRIMARY KEY'
      t.integer :user_id
      t.string :name
      t.string :screen_name
      t.string :text
      t.column :in_reply_to_status_id, 'bigint(19)'
      t.string :in_reply_to_screen_name
      t.datetime :created_at
    end
  end
end
