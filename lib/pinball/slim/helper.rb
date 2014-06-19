module Pinball
  module Slim
    module Helper
      def feature(name, opts_or_locals = {})
        if Pinball::Registry.available?(name)
          partial_name = opts_or_locals.fetch(:partial, name)
          locals = opts_or_locals.tap { |h| h.delete(:partial) }
          partial "features/#{partial_name}", locals
        end
      end
    end
  end
end
