require 'pinball_wizard/helpers/string'

# Further Reading: https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along
module PinballWizard
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

      # Convert [:a, :b, { c: 'd' }] => { a: true, b: true, c: 'd' }
      def normalize_options(options)
        options.each_with_object({}) do |opt, memo|
          if opt.is_a?(::Hash)
            memo.merge!(opt)
          else
            memo[opt] = true
          end
        end
      end

      def without(hash, *keys)
        keys.each do |key|
          hash.delete(key)
        end
        hash
      end
    end
  end
end

