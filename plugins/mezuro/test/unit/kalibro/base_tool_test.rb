require "test_helper"
require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/base_tool_fixtures"

class BaseToolTest < ActiveSupport::TestCase

  def setup
    @hash = BaseToolFixtures.base_tool_hash
    @base_tool = BaseToolFixtures.base_tool
  end

  should 'create base tool from hash' do
    assert_equal @hash[:name], Kalibro::BaseTool.new(@hash).name
  end
  
  should 'get base tool by name' do
    request_body = {:base_tool_name => @base_tool.name}
    Kalibro::BaseTool.expects(:request).with(:get_base_tool, request_body).returns({:base_tool => @hash})
    assert_equal @base_tool, Kalibro::BaseTool.find_by_name(@base_tool.name)
  end

  should 'get all base tools' do
    names = ['Analizo', 'Checkstyle']
    Kalibro::BaseTool.expects(:all_names).returns(names)
    Kalibro::BaseTool.expects(:find_by_name).twice.returns(@base_tool)
    assert_equal [@base_tool, @base_tool], Kalibro::BaseTool.all
  end
  
  should 'get base tool names' do
    names = ['Analizo', 'Checkstyle']
    Kalibro::BaseTool.expects(:request).with(:all_base_tool_names).returns({:base_tool_name => names})
    assert_equal names, Kalibro::BaseTool.all_names
  end

end
