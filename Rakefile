require 'active_record'
require 'yaml'

task :default => :migrate

desc 'Migrate database'
task :migrate => :environment do
  module ActiveRecord
    module ConnectionAdapters
      class AbstractMysqlAdapter
        def create_table(table_name, options = {}) #:nodoc:
          super(table_name, options.reverse_merge(:options => "ENGINE=InnoDB ROW_FORMAT=COMPRESSED"))
        end
      end
    end
  end
  ActiveRecord::Migrator.migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil )
end

task :environment do
  dbconfig = YAML.load_file('config/config.yml')
  ActiveRecord::Base.establish_connection(dbconfig['db'][ENV['ENV'] ? ENV['ENV'] : 'development'])
  ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end
