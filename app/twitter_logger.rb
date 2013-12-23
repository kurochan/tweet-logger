require 'userstream'
require 'time'
require 'pp'

class TwitterLogger
  attr_reader :client

  def initialize
    @client = nil
    UserStream.configure do |config|
      config.consumer_key = CONFIG['twitter']['consumer_key']
      config.consumer_secret = CONFIG['twitter']['consumer_secret']
      config.oauth_token = CONFIG['twitter']['access_token']
      config.oauth_token_secret = CONFIG['twitter']['access_token_secret']
    end
  end

  def start
    Thread.new do
      loop do
        @client = UserStream.client
        puts 'Start UserStream'
        begin
          @client.user do |status|
            if status['text']
              save_status status
            elsif status['delete']
              save_deleted_status status
            end
          end
        rescue => e
          puts e.class
          puts e.message
          puts e.backtrace
          puts 'ERROR: retry...'
        end
        sleep 5
      end
    end
  end

  private
  def save_status(status)
    tweet = Tweet.new
    tweet.id = status['id']
    tweet.user_id = status['user']['id']
    tweet.name = status['user']['name']
    tweet.screen_name = status['user']['screen_name']
    tweet.text = status['text']
    tweet.in_reply_to_status_id = status['in_reply_to_status_id']
    tweet.in_reply_to_screen_name = status['in_reply_to_screen_name']
    tweet.created_at = Time.parse(status['created_at'])
    tweet.save
  end

  def save_deleted_status(status)
    deleted_tweet = DeletedTweet.new
    deleted_tweet.id = status['delete']['status']['id']
    deleted_tweet.user_id =status['delete']['status']['user_id']
    deleted_tweet.deleted_at = Time.now
    deleted_tweet.save
  end
end
