module Pinball
  module Helpers
    module String
      module_function

      # Pfft, no need for ActiveSupport.

      def camelize(str)
        pieces = str.to_s.split('_').each_with_index.map do |w, i|
          i == 0 ? w : w.capitalize
        end
        pieces.join
      end

      def underscore(str)
        str.split(/(?=[A-Z])/).join('_').downcase
      end
    end
  end
end