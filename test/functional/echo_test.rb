require File.dirname(__FILE__) + '/../test_helper'

class EchoTest < ActiveSupport::TestCase
  should "not duplicate ids" do
    echo = Factory(:echo)
    echo.relayed!(124)
    echo.relayed!("124")
    assert_equal "124", echo.relayed_ids
  end
end
