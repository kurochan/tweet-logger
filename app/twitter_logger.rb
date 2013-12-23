require 'userstream'
require 'time'

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
            next unless status['text']

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
end
