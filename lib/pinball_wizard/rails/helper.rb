module PinballWizard
  module Rails
    module Helper
      def feature(name, opts_or_locals = {})
        if PinballWizard::Registry.available?(name)
          partial_name = opts_or_locals.fetch(:partial, name)
          locals = opts_or_locals.tap { |h| h.delete(:partial) }
          render partial: "features/#{partial_name}", locals: locals
        end
      end
    end
  end
end
