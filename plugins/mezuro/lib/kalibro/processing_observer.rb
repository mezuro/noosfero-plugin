class Kalibro::ProcessingObserver < Kalibro::Model
  
  attr_accessor :id, :name, :email, :repository_id

  def self.all
    create_objects_array_from_hash request(:all_processing_observers)[:processing_observer]
  end

  private

  def save_params
    {:processing_observer => self.to_hash, :repository_id => repository_id}
  end

end