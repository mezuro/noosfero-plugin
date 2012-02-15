require "test_helper"

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/module_fixtures"

class ModuleTest < ActiveSupport::TestCase

  def setup
    @hash = ModuleFixtures.qt_calculator_hash
    @module = ModuleFixtures.qt_calculator
  end

  should 'create module from hash' do
    assert_equal @module, Kalibro::Entities::Module.from_hash(@hash)
  end
  
  should 'convert module to hash' do
    assert_equal @hash, @module.to_hash
  end

end