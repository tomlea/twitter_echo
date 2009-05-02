# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "oauth", :lib => "twitter_oauth", :version => ">= 0.3.1"
  config.gem "moomerman-twitter_oauth", :lib => "twitter_oauth", :source => "http://gems.github.com/"
  config.time_zone = 'UTC'
end
