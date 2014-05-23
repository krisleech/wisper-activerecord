begin
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
rescue LoadError
end

require 'wisper'
require 'active_record'

puts "Using ActiveRecord #{ActiveRecord::VERSION::STRING}"

adapter = RUBY_PLATFORM == "java" ? 'jdbcsqlite3' : 'sqlite3'

ActiveRecord::Base.establish_connection(:adapter => adapter,
                                        :database => File.dirname(__FILE__) + "/db.sqlite3")

load File.dirname(__FILE__) + '/support/schema.rb'

require 'support/models'

require 'wisper/activerecord'

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.full_backtrace = true
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
