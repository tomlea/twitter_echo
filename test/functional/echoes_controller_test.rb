require File.dirname(__FILE__) + '/../test_helper'

class EchoesControllerTest < ActionController::TestCase
  context "With no session in progress" do
    context "the index page" do
      setup{ get :index }

      should_respond_with :success
      should_render_template :index
    end
  end

  context "When client is authorized" do
    setup do
      authorised_client = stub(:authorised_client)
      authorised_client.stubs(:authorized?).returns(true)
      authorised_client.stubs(:info).returns({"screen_name" => "bot_account"})
      EchoesController.any_instance.stubs(:client).returns(authorised_client)
    end

    context "the index page" do
      setup{ get :index }
      should_redirect_to("new echo path"){ new_echo_path }
    end

    context "and we already have a echo account for it" do
      setup do
        @echo = Factory(:echo, :username => "bot_account" )
      end

      context "the index page" do
        setup{ get :index }
        should_redirect_to("existing echo"){ echo_path(@echo) }
      end
    end
  end
end
