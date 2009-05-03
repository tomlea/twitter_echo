require File.dirname(__FILE__) + '/../test_helper'

class EchoesControllerTest < ActionController::TestCase
  context "With no session in progress" do
    setup do
      get :index
    end
    should_respond_with :success
    should_render_template :index
  end
end
