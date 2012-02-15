require "test_helper"

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/project_fixtures"

class ProjectContentTest < ActiveSupport::TestCase

  def setup
    @project = ProjectFixtures.qt_calculator
    @content = MezuroPlugin::ProjectContent.new
    @content.name = @project.name
    @content.license = @project.license
    @content.description = @project.description
    @content.repository_type = @project.repository.type
    @content.repository_url = @project.repository.address
    @content.configuration_name = @project.configuration_name
  end

  should 'be an article' do
    assert_kind_of Article, @content
  end

  should 'provide proper short description' do
    assert_equal 'Kalibro project', MezuroPlugin::ProjectContent.short_description
  end

  should 'provide proper description' do
    assert_equal 'Software project tracked by Kalibro', MezuroPlugin::ProjectContent.description
  end

  should 'have an html view' do
    assert_not_nil @content.to_html
  end

  should 'get project from service' do
    Kalibro::Client::ProjectClient.expects(:project).with(@content.name).returns(@project)
    assert_equal @project, @content.project
  end

  should 'get project result from service' do
    project_result = mock
    Kalibro::Client::ProjectResultClient.expects(:last_result).with(@content.name).returns(project_result)
    assert_equal project_result, @content.project_result
  end

  should 'get module result from service' do
    module_name = 'My module name'
    module_result = mock
    Kalibro::Client::ModuleResultClient.expects(:module_result).with(@content, module_name).
      returns(module_result)
    assert_equal module_result, @content.module_result(module_name)
  end

  should 'run send project to service on after_save callback' do
    @content.expects :send_project_to_service
    @content.run_callbacks :after_save
  end

  should 'send correct project to service' do
    Kalibro::Client::ProjectClient.expects(:save).with(@content)
    Kalibro::Client::KalibroClient.expects(:process_project).with(@project.name)
    @content.send :send_project_to_service
  end

  should 'remove project from service' do
    Kalibro::Client::ProjectClient.expects(:remove).with(@project.name)
    @content.send :remove_project_from_service
  end
end