require "test_helper"

require "#{RAILS_ROOT}/plugins/mezuro/test/fixtures/processing_observer_fixtures"

class ProcessingObserverTest < ActiveSupport::TestCase

  should 'save processing observer' do
    processing_observer_id_from_kalibro = 2
    processing_observer = ProcessingObserverFixtures.processing_observer
    Kalibro::ProcessingObserver.expects(:request).with(:save_processing_observer, 
          {
            :processing_observer => ProcessingObserverFixtures.processing_observer_hash,
            :repository_id => processing_observer.repository_id

          }).returns(:processing_observer_id => processing_observer_id_from_kalibro)
    assert processing_observer.save
    assert_equal processing_observer_id_from_kalibro, processing_observer.id
  end

end
