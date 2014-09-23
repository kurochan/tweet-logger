require 'twitter'
require 'time'
require 'pp'

class TwitterLogger
  def start
    Thread.new do
      loop do
        puts 'Start UserStream'
        begin
          client = get_twitter_instance
          client.sample do |status|
            next unless status.is_a?(Twitter::Tweet) && status.user.lang == 'ja'
      	    save_status status
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
  def get_twitter_instance
    Twitter::Streaming::Client.new(
      :consumer_key => CONFIG['twitter']['consumer_key'],
      :consumer_secret => CONFIG['twitter']['consumer_secret'],
      :access_token => CONFIG['twitter']['access_token'],
      :access_token_secret => CONFIG['twitter']['access_token_secret']
    )
  end

  def save_status(status)
    tweet = Tweet.new
    tweet.id = status.id
    tweet.user_id = status.user.id
    tweet.name = status.user.name
    tweet.screen_name = status.user.screen_name
    tweet.text = status.text
    tweet.lang = status.lang
    tweet.in_reply_to_status_id = status.in_reply_to_status_id
    tweet.in_reply_to_screen_name = status.in_reply_to_screen_name
    tweet.created_at = status.created_at
    begin
      tweet.save
    rescue ActiveRecord::RecordNotUnique
    end
  end

  def save_deleted_status(status)
    deleted_tweet = DeletedTweet.new
    deleted_tweet.id = status.delete.status.id
    deleted_tweet.user_id =status.delete.status.user_id
    deleted_tweet.deleted_at = Time.now
    deleted_tweet.save
  end
end
