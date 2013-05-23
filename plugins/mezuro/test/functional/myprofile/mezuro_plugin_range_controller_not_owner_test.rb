require 'test_helper'

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/metric_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/metric_configuration_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/configuration_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/range_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/reading_fixtures"

class MezuroPluginRangeControllerNotOwnerTest < ActionController::TestCase

  def setup
    @controller = MezuroPluginRangeController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @profile = fast_create(Profile)
    @not_owner = fast_create(User, :id =>"5")

    @metric_configuration = MetricConfigurationFixtures.amloc_metric_configuration

    @configuration = ConfigurationFixtures.configuration

    @content = MezuroPlugin::ConfigurationContent.new(:profile => @profile, :name => @configuration.name, :configuration_id => 42)
    @content.expects(:send_configuration_to_service).returns(nil)
    @content.expects(:validate_configuration_name).returns(true)
    @content.stubs(:solr_save)
    @content.save

    @range = RangeFixtures.range
    @created_range_hash = RangeFixtures.created_range_hash



  end

  should 'not set attributes to create a new range when not logged' do
    get :new, :profile => @profile.identifier, :id => @content.id, 
        :metric_configuration_id => @metric_configuration.id, 
        :reading_group_id => @metric_configuration.reading_group_id, 
        :compound => @metric_configuration.metric.compound
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not set attributes to create a new range when it is not the owner' do
    get :new, :profile => @profile.identifier, :id => @content.id, 
        :metric_configuration_id => @metric_configuration.id, 
        :reading_group_id => @metric_configuration.reading_group_id, 
        :compound => @metric_configuration.metric.compound, 
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not set attributes to edit a range when not logged' do
    get :edit, :profile => @profile.identifier, :id => @content.id, 
        :metric_configuration_id => @metric_configuration.id,
        :range_id => @range.id, 
        :reading_group_id => @metric_configuration.reading_group_id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not set attributes to edit a range when it is not the owner' do
    get :edit, :profile => @profile.identifier, :id => @content.id, 
        :metric_configuration_id => @metric_configuration.id,
        :range_id => @range.id, 
        :reading_group_id => @metric_configuration.reading_group_id, 
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not create instance range when not logged' do
    get :create, :profile => @profile.identifier, 
        :range => @created_range_hash,
        :metric_configuration_id => @metric_configuration.id,
        :reading_group_id => @metric_configuration.reading_group_id,
        :compound => @metric_configuration.metric.compound
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not create instance range when it is not the owner' do
    get :create, :profile => @profile.identifier, 
        :range => @created_range_hash,
        :metric_configuration_id => @metric_configuration.id,
        :reading_group_id => @metric_configuration.reading_group_id, 
        :compound => @metric_configuration.metric.compound,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not update range when not logged' do
    get :update, :profile => @profile.identifier, 
        :range => @created_range_hash,
        :metric_configuration_id => @metric_configuration.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not update range when it is not the owner' do
    get :update, :profile => @profile.identifier, 
        :range => @created_range_hash,
        :metric_configuration_id => @metric_configuration.id,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not remove range in native when not logged' do
    get :remove, :profile => @profile.identifier, :id => @content.id,
        :metric_configuration_id => @metric_configuration.id, 
        :range_id => @range.id, 
        :compound => false
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not remove range in native when it is not the owner' do
    get :remove, :profile => @profile.identifier, :id => @content.id,
        :metric_configuration_id => @metric_configuration.id, 
        :range_id => @range.id, 
        :compound => false,
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

end