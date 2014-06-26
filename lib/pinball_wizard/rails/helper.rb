module PinballWizard
  module Rails
    module Helper
      def feature(name, options = {})
        if PinballWizard::Registry.available?(name)
          partial_name = options.fetch(:partial) { name }
          options[:partial] = "features/#{partial_name}"
          render options
        end
      end
    end
  end
end
