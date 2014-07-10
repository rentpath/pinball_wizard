require 'pinball_wizard/helpers/hash'

module PinballWizard
  module DSL
    def self.build(config = PinballWizard.configuration, &block)
      builder = Builder.new(config)
      builder.instance_eval(&block)
      builder
    end

    class Builder
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def feature(name, *options)
        options = Helpers::Hash.normalize_options(options)
        feature = build_feature(name, options)
        Registry.add(feature)
      end

      private

      def build_feature(name, options)
        build_from_class_pattern(name, options) || Feature.new(name, options)
      end

      def build_from_class_pattern(name, options)
        config.class_patterns.each_pair do |key, klass|
          return klass.new(name, options) if options.keys.include?(key)
        end
        false
      end
    end
  end
end
