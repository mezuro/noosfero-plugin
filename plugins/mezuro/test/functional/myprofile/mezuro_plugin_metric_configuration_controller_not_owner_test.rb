require 'test_helper'

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/configuration_fixtures"

class MezuroPluginMetricConfigurationControllerNotOwnerTest < ActionController::TestCase

  def setup
    @controller = MezuroPluginMetricConfigurationController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @profile = fast_create(Profile)
    @not_owner_profile = fast_create(Profile, :id =>"5")

    @configuration = ConfigurationFixtures.configuration
    @created_configuration = ConfigurationFixtures.created_configuration
    @configuration_hash = ConfigurationFixtures.configuration_hash

    @configuration_content = MezuroPlugin::ConfigurationContent.new(:profile => @profile, :name => @configuration.name, :configuration_id => 42)
    @configuration_content.expects(:send_configuration_to_service).returns(nil)
    @configuration_content.expects(:validate_configuration_name).returns(true)
    @configuration_content.stubs(:solr_save)
    @configuration_content.save
  end

  should 'not choose metric when not logged in' do
    get :choose_metric, :profile => @profile.identifier, :id => @configuration_content.id
    assert_redirected_to :profile=>@profile.identifier, :action=>"error_page", :controller=>"mezuro_plugin_myprofile",
                          :message=>"You are not authorized to access this page"

  end

end
