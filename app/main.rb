require 'yaml'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + '/twitter_logger.rb')

CONFIG = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/config.yml'))
$stdout.sync = true

db_config  = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/database.yml'))
ActiveRecord::Base.establish_connection(db_config['db'][ENV['ENV'] ? ENV['ENV'] : 'development'])
ActiveRecord::Base.default_timezone = :local

Dir[File.expand_path('../model', __FILE__) << '/*.rb'].each do |file|
  require file
end

twitter_logger = TwitterLogger.new
thread = twitter_logger.start
thread.join
