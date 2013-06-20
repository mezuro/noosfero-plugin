require 'test_helper'

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/processing_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/throwable_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/repository_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/project_content_fixtures"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/configuration_fixtures"

class MezuroPluginRepositoryObserverControllerTest < ActionController::TestCase

  def setup
    @controller = MezuroPluginRepositoryObserverController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @profile = fast_create(Community)

    @content = MezuroPlugin::ProjectContent.new(:profile => @profile, :name => name)
    @content.expects(:send_project_to_service).returns(nil)
    @content.stubs(:solr_save)
    @content.save
  end

  should 'set variables to create a new repository observer' do

    get :new, :profile => @profile.identifier, :id => @content.id

  end

end