require 'test_helper'

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/reading_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/reading_group_content_fixtures"

class MezuroPluginReadingControllerNotOwnerTest < ActionController::TestCase

  def setup
    @controller = MezuroPluginReadingController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @profile = fast_create(Profile)
    @not_owner = fast_create(User, :id =>"5")


    @reading = ReadingFixtures.reading
    @created_reading = ReadingFixtures.created_reading
    @reading_hash = ReadingFixtures.hash

    @content = MezuroPlugin::ReadingGroupContent.new(:profile => @profile, :name => name)
    @content.expects(:send_reading_group_to_service).returns(nil)
    @content.stubs(:solr_save)
    @content.save
  end

  should 'not set variables to create a new reading when not logged' do
    get :new, :profile => @profile.identifier, :id => @content.id 
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not set variables to create a new reading when it is not the owner' do
    get :new, :profile => @profile.identifier, :id => @content.id, 
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not create reading when not logged' do
    get :save, :profile => @profile.identifier, :id => @content.id, 
        :reading => @reading_hash
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not create reading when it is not the owner' do
    get :save, :profile => @profile.identifier, :id => @content.id, 
        :reading => @reading_hash, 
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not set variables to edit a reading when not logged' do
    get :edit, :profile => @profile.identifier, :id => @content.id, 
        :reading_id => @reading.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not set variables to edit a reading when it is not the owner' do
    get :edit, :profile => @profile.identifier, :id => @content.id, 
        :reading_id => @reading.id, 
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not destroy a reading when not logged' do
    get :destroy, :profile => @profile.identifier, :id => @content.id, 
        :reading_id => @reading.id
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

  should 'not destroy a reading when it is not the owner' do
    get :destroy, :profile => @profile.identifier, :id => @content.id, 
        :reading_id => @reading.id, 
        :user => @not_owner
    assert_redirected_to :profile => @profile.identifier, :action => "error_page",
                          :controller => "mezuro_plugin_myprofile",
                          :message => "You are not authorized to access this page"
  end

end