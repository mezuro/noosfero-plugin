require "test_helper"

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/project_result_fixtures"

class ProjectResultTest < ActiveSupport::TestCase

  def setup
    @hash = ProjectResultFixtures.qt_calculator_hash
    @result = ProjectResultFixtures.qt_calculator
  end

  should 'create project result from hash' do
    assert_equal @result, Kalibro::Entities::ProjectResult.from_hash(@hash)
  end

  should 'convert project result to hash' do
    assert_equal @hash, @result.to_hash
  end

  should 'retrieve formatted load time' do
    assert_equal '00:00:14', @result.formatted_load_time
  end

  should 'retrieve formatted analysis time' do
    assert_equal '00:00:01', @result.formatted_analysis_time
  end
  
end