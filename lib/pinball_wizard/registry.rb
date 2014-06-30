require 'pinball_wizard/helpers/hash'

# Further Reading: https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along
module PinballWizard
  module Registry
    extend self

    def add(feature)
      collection[feature.name.to_s] = feature
    end

    def get(name)
      collection[name.to_s]
    end

    def available?(name)
      feature = collection.fetch(name.to_s) { null_feature }
      feature.available?
    end

    def collection
      @collection ||= {}
    end

    def clear
      @collection = {}
    end

    def to_h
      Helpers::Hash.camelize_hash_keys(collection)
    end

    alias_method :to_hash, :to_h

    private

    def null_feature
      Feature.new 'null_feature', available: false
    end
  end
end
