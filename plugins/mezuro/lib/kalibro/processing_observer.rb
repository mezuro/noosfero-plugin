class Kalibro::ProcessingObserver
  
  attr_accessor :name, :email

  def initialize(attributes={})
    self.name = attributes[:name]
    self.email = attributes[:email]
  end
end