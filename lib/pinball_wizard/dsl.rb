module PinballWizard
  module DSL
    def self.build(&block)
      builder = Builder.new
      builder.instance_eval(&block)
      builder
    end

    class Builder
      def feature(name, *options)
        feature = Feature.new(name, *options)
        Registry.add(feature)
      end
    end
  end
end
