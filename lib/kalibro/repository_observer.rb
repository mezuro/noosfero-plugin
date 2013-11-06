class Kalibro::RepositoryObserver < Kalibro::Model
  
  attr_accessor :id, :name, :email, :repository_id

  def self.all
    create_objects_array_from_hash request(:all_repository_observers)[:repository_observer]
  end

  private

  def save_params
    {:repository_observer => self.to_hash, :repository_id => repository_id}
  end

end