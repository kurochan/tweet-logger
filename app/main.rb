require 'yaml'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + '/twitter_logger.rb')

CONFIG = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/config.yml'))
$stdout.sync = true

ActiveRecord::Base.establish_connection(CONFIG['db'][ENV['ENV'] ? ENV['ENV'] : 'development'])
ActiveRecord::Base.default_timezone = :local

Dir[File.expand_path('../model', __FILE__) << '/*.rb'].each do |file|
  require file
end

puts "Start Logger: ENV = #{ENV['ENV'] ? ENV['ENV'] : 'development'}"
twitter_logger = TwitterLogger.new
thread = twitter_logger.start
thread.join
