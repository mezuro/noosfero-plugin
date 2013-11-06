class Kalibro::Project < Kalibro::Model

  attr_accessor :id, :name, :description

  def id=(value)
    @id = value.to_i
  end

  def self.all
    create_objects_array_from_hash request(:all_projects)[:project]
  end
end
