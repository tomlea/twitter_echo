ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require File.join(File.dirname(__FILE__), "factories")

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
end
