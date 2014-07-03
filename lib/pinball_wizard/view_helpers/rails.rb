module PinballWizard
  module ViewHelpers
    module Rails
      def feature(name, options = {})
        unless PinballWizard::Registry.disabled?(name)
          partial_name = options.fetch(:partial) { name }
          options[:partial] = "features/#{partial_name}"
          render options
        end
      end
    end
  end
end
