module PinballWizard
  class NullFeature < Feature
    def determine_state
      disable 'Feature not found'
    end
  end
end
