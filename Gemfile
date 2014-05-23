source 'https://rubygems.org'

gemspec

gem 'rubysl', '~> 2.0', :platforms => :rbx

group :test do
  gem "sqlite3",                          :platform => :ruby
  gem "activerecord-jdbcsqlite3-adapter", :platform => :jruby
  gem 'simplecov'
end

group :metrics do
  gem 'flay'
end
