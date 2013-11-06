class RepositoryObserverFixtures

  def self.repository_observer
    Kalibro::RepositoryObserver.new repository_observer_hash
  end

  def self.repository_observer_hash
    {:name => 'Owner', :email => "owner@email.com", :repository_id => "42"}
  end
end