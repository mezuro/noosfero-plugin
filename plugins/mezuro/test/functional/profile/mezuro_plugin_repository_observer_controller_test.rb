require 'test_helper'

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/processing_observer_fixtures"

class MezuroPluginRepositoryObserverControllerTest < ActionController::TestCase

  def setup
    @controller = MezuroPluginRepositoryObserverController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @profile = fast_create(Community)

    @project_content = MezuroPlugin::ProjectContent.new(:profile => @profile, :name => name)
    @project_content.expects(:send_project_to_service).returns(nil)
    @project_content.stubs(:solr_save)
    @project_content.save
  end

  should 'set variables to create a new repository observer' do
    repository_id = "2"

    get :new, :profile => @profile.identifier, :id => @project_content.id,  :repository_id => repository_id

    assert_equal @project_content.id, assigns(:project_content).id
    assert_equal repository_id, assigns(:repository_id)

    assert_response :success
  end

  should 'save repository observer and redirect back to repository page' do
    fixture = ProcessingObserverFixtures
    repository_observer = fixture.processing_observer

    Kalibro::ProcessingObserver.expects(:new).with(fixture.processing_observer_hash).returns(repository_observer)
    repository_observer.expects(:save).returns(true)

    get :save, :profile => @profile.identifier, :id => @project_content.id,  :repository_id => repository_observer.repository_id, :repository_observer => repository_observer.to_hash

    assert_response :redirect
  end


end