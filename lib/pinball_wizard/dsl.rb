module PinballWizard
  module DSL
    def self.build(&block)
      builder = Builder.new
      builder.instance_eval(&block)
      builder
    end

    class Builder
      attr_reader :class_patterns_repo

      def initialize
        @class_patterns_repo = {}
      end

      def feature(name, *options)
        feature = build_feature(name, *options)
        Registry.add(feature)
      end

      def build_feature(name, *options)
        class_patterns_repo.each_pair do |key, klass|
          return klass.new(name, *options) if options.include?(key)
        end
        Feature.new(name, *options)
      end

      def class_patterns(hash)
        @class_patterns_repo = hash
      end
    end
  end
end
