require 'pinball_wizard/helpers/hash'
require 'pinball_wizard/null_feature'

# Further Reading: https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along
module PinballWizard
  module Registry
    extend self

    def add(feature)
      collection[feature.name] = feature
    end

    def get(name)
      collection.fetch(name.to_s) { null_feature }
    end

    def disabled?(name)
      get(name).disabled?
    end

    def collection
      @collection ||= {}
    end

    def clear
      @collection = {}
    end

    def to_h
      pairs = collection.map do |name, feature|
        [feature.to_s, feature.state]
      end
      ::Hash[pairs]
    end

    alias_method :to_hash, :to_h

    private

    def null_feature
      @null_feature ||= NullFeature.new 'null'
    end
  end
end
