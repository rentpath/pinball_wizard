module PinballWizard
  module Rails
    module Slim
      module Helper
        def feature(name)
          if PinballWizard::Registry.available?(name)
            # Placeholder for future integration
          end
        end
      end
    end
  end
end
