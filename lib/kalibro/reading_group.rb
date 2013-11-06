class Kalibro::ReadingGroup < Kalibro::Model

  attr_accessor :id, :name, :description

  def id=(value)
    @id = value.to_i
  end

  def self.all
    create_objects_array_from_hash request(:all_reading_groups)[:reading_group]
  end
  
  def self.reading_group_of( metric_configuration_id )
    new request(:reading_group_of, {:metric_configuration_id => metric_configuration_id} )[:reading_group]
  end

  private

  def self.id_params(id)
    {:group_id => id}
  end
  
  def destroy_params
    {:group_id => self.id}
  end

end
