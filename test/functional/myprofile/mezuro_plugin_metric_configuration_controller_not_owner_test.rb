require 'test_helper'

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/metric_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/metric_configuration_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/configuration_fixtures"

class MezuroPluginMetricConfigurationControllerNotOwnerTest < ActionController::TestCase

  def setup
    @controller = MezuroPluginMetricConfigurationController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @profile = fast_create(Profile, :user_id => "7")
    @not_owner = fast_create(User, :id =>"5")

    @configuration = ConfigurationFixtures.configuration
    @created_configuration = ConfigurationFixtures.created_configuration
    @configuration_hash = ConfigurationFixtures.configuration_hash

    @configuration_content = MezuroPlugin::ConfigurationContent.new(:profile => @profile, :name => @configuration.name, :configuration_id => 42)
    @configuration_content.expects(:send_configuration_to_service).returns(nil)
    @configuration_content.expects(:validate_configuration_name).returns(true)
    @configuration_content.stubs(:solr_save)
    @configuration_content.save

    @base_tool = BaseToolFixtures.base_tool

    @metric = MetricFixtures.amloc

    @native_metric_configuration = MetricConfigurationFixtures.amloc_metric_configuration
    @native_metric_configuration_hash = MetricConfigurationFixtures.amloc_metric_configuration_hash
    @compound_metric_configuration = MetricConfigurationFixtures.sc_metric_configuration
    @compound_metric_configuration_hash = MetricConfigurationFixtures.sc_metric_configuration_hash
  end

  should 'not choose metric when not logged in' do
    get :choose_metric, :profile => @profile.identifier,
        :id => @configuration_content.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not choose metric when it is not the owner' do
    get :choose_metric, :profile => @profile.identifier,
        :id => @configuration_content.id, :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not initialize native when not logged in' do
    get :new_native, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :base_tool_name => @base_tool.name,
        :metric_name => @metric.name
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not initialize native when it is not the owner' do
    get :new_native, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :base_tool_name => @base_tool.name,
        :metric_name => @metric.name,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not edit native when not logged in' do
    get :edit_native, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @native_metric_configuration.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not edit native when it is not the owner' do
    get :edit_native, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @native_metric_configuration.id,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not initialize compound when not logged in' do
    get :new_compound, :profile => @profile.identifier,
        :id => @configuration_content.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not initialize compound when it is not the owner' do
    get :new_compound, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not edit compound when not logged in' do
    get :edit_compound, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @compound_metric_configuration.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not edit compound when it is not the owner' do
    get :edit_compound, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @compound_metric_configuration.id,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not create metric when not logged in' do
    get :create, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration => @compound_metric_configuration_hash
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not create metric when it is not the owner' do
    get :create, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration => @compound_metric_configuration_hash,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not update native metric configuration when not logged in' do
    get :update, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration => @native_metric_configuration_hash
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not update native metric configuration when it is not the owner' do
    get :update, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration => @native_metric_configuration_hash,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not update compound metric configuration when not logged in' do
    get :update, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration => @compound_metric_configuration_hash
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not update compound metric configuration when it is not the owner' do
    get :update, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration => @compound_metric_configuration_hash,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not remove native metric configuration when not logged in' do
    get :remove, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @native_metric_configuration.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not remove native metric configuration when it is not the owner' do
    get :remove, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @native_metric_configuration.id,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not remove compound metric configuration when not logged in' do
    get :remove, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @compound_metric_configuration.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not remove compound metric configuration when it is not the owner' do
    get :remove, :profile => @profile.identifier,
        :id => @configuration_content.id,
        :metric_configuration_id => @compound_metric_configuration.id,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

end
