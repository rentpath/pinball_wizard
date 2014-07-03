module PinballWizard
  module ViewHelpers
    module Sinatra
      module Slim
        def feature(name, opts_or_locals = {})
          unless PinballWizard::Registry.disabled?(name)
            partial_name = opts_or_locals.fetch(:partial) { name }
            locals = opts_or_locals.tap { |h| h.delete(:partial) }
            partial "features/#{partial_name}", locals
          end
        end
      end
    end
  end
end
