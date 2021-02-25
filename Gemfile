source 'https://rubygems.org'
ruby "2.6.6"
#ruby-gemset=dcsops

# The following are from the default generated Gemfile for a new Rails 5.2 app:

gem 'rails', '~> 5.2.4', '>= 5.2.4.3' # This is the version string generated by `rails new` on the current latest ~> 5 version of rails (5.2.4.3)
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby # Default Rails 5.2 uses mini_racer, but we're already using therubyracer, so we'll stay with that for now.
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

# The following are gems required by the application itself:

gem 'rack-rewrite'
gem 'pg', '~> 0.2'

gem 'arcdata_core', github: 'redcross/arcdata_core', branch: 'upgrade/rails-6'
gem 'connect', github: 'redcross/openid-connect-engine', branch: 'rails-6-upgrade'

gem 'activerecord-postgresql-adapter'
gem 'activerecord-import'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'haml-rails'
gem "less-rails"

gem 'delayed_job_active_record'

gem 'inherited_resources'
gem 'responders'
gem 'has_scope'
gem "twitter-bootstrap-rails", '~> 3.1.0', github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'
gem 'bootstrap-x-editable-rails'
gem "spreadsheet" # Import from excel

gem 'scrypt'
gem "authlogic"

gem "omniauth_openid_connect"

gem "ri_cal" # Ical Rendering
gem "cancancan"
gem "cancan-inherited_resources" # cancancan v2 and later don't have built-in support for use with inherited_resources
gem "ruby-openid", require: 'openid'
gem "timeliness"
gem "roadie-rails"
gem "kaminari"
gem "paper_trail"
gem "assignable_values"
gem 'bootstrap-kaminari-views'
gem 'paperclip'
gem 'threach'
gem 'restforce'
gem 'dotiw'

gem 'geokit'#, github: 'mikefarmer/geokit' # Found a branch that removes some weird build stuff

gem 'formtastic'
gem 'formtastic-bootstrap'
gem 'cocoon'
gem 'activeadmin'
gem 'nokogiri'

# Monitoring/Alerting
gem 'sentry-raven'
gem 'hashie', '~>2.0.0'
gem 'newrelic_rpm', '< 4'

gem 'httparty'
gem 'couchrest'
gem 'ruby-bitly'
gem 'aws-sdk'
gem "memcachier"
gem "dalli"
gem "twilio-ruby"
gem 'pubnub'

gem 'pdfkit'
gem 'wkhtmltopdf-heroku', :group => [:staging, :production]
gem 'wkhtmltopdf-binary', group: :development


group :test do
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'rails-controller-testing'
  gem 'faker'
  gem 'zonebie'
  gem 'sqlite3'

  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'delorean'
  gem 'coveralls', require: false

  gem 'capybara', require: false
  gem 'apparition'
  gem 'capybara-screenshot', require: false
  gem 'database_cleaner', '~> 1.0.1', require: false # Current 1.1.1 version has catastrophic issue that breaks DB adapters.  Can upgrade when fixed
  #gem 'sauce' # Quite possibly the most annoying, complex, fragile gem in existence
  gem 'parallel_tests'

  gem 'webmock'
  gem 'vcr'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'autotest'
  #gem 'autotest-fsevent'

  gem 'http_logger'

  gem 'ruby-prof'
  gem 'spring-commands-rspec'

  gem 'better_errors'
  gem 'binding_of_caller'

  # The following are from the default generated Gemfile for a new Rails 5.2 app:

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
