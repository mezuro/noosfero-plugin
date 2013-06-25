class ProcessingObserverFixtures

  def self.processing_observer
    Kalibro::ProcessingObserver.new processing_observer_hash
  end

  def self.processing_observer_hash
    {:name => 'Owner', :email => "owner@email.com", :repository_id => "42"}
  end
end