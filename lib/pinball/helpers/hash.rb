require 'pinball/helpers/hash'

# Further Reading: https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along
module Pinball
  module Helpers
    module Hash
      module_function

      # foo: { bar_baz: 'v' }
      #  =>
      # 'foo' => { 'barBaz' => 'v' }
      def camelize_hash_keys(hash)
        pairs = hash.map do |name, value|
          [name.to_s, camelize_keys(value.to_hash)]
        end
        ::Hash[pairs]
      end

      def camelize_keys(hash)
        camelized = hash.map do |k, v|
          [String.camelize(k), v]
        end
        ::Hash[camelized]
      end
    end
  end
end

