module PinballWizard
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :class_patterns

    def initialize(class_patterns = {})
      @class_patterns = class_patterns
    end
  end
end
