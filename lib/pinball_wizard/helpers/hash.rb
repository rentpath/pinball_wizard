# Further Reading: https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along
module PinballWizard
  module Helpers
    module Hash
      module_function

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
