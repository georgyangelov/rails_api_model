module DatabaseHelpers
  TEMP_DB_FILE = File.expand_path('../../tmp/database.sqlite3', __FILE__)

  def create_schema(&block)
    ActiveRecord::Migration.class_eval(&block)
  end

  def create_db_model(class_name, &block)
    Class.new(ActiveRecord::Base) do
      define_singleton_method :name do
        class_name.to_s.camelize
      end

      class_exec &block if block_given?
    end
  end

  def connect_to_database
    FileUtils.mkdir_p File.dirname(TEMP_DB_FILE)
    ActiveRecord::Base.establish_connection(
       adapter:  'sqlite3',
       database: TEMP_DB_FILE
    )
  end

  def reload_database
    remove_database
    connect_to_database
  end

  def remove_database
    ActiveRecord::Base.remove_connection
    File.unlink TEMP_DB_FILE if File.file? TEMP_DB_FILE
  end
end

RSpec.configure do |config|
  config.include DatabaseHelpers

  config.before(:each) { reload_database }
end
