require 'yaml'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + '/twitter_logger.rb')

ENV['ENV'] = 'development' unless ENV['ENV']
CONFIG = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/config.yml'))
$stdout.sync = true

ActiveRecord::Base.establish_connection(CONFIG['db'][ENV['ENV']])
ActiveRecord::Base.default_timezone = :local

Dir[File.expand_path('../model', __FILE__) << '/*.rb'].each do |file|
  require file
end

puts "Start Logger: ENV = #{ENV['ENV']}"
twitter_logger = TwitterLogger.new
thread = twitter_logger.start
thread.join
