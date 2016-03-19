module DatabaseHelpers
  TEMP_DB_FILE = File.expand_path('../../tmp/database.sqlite3', __FILE__)

  def create_schema(&block)
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migration.class_eval(&block)
  end

  def create_ar_model(name, &block)
    model = Class.new(ActiveRecord::Base) do
      class_exec &block if block_given?
    end

    stub_const name.to_s.classify, model
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
