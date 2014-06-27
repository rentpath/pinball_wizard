require 'pinball_wizard/helpers/hash'

# Further Reading: https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along
module PinballWizard
  module Registry
    extend self

    def add(feature)
      collection[feature.name] = feature
    end

    def available?(name)
      feature = collection.fetch(name) { null_feature }
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
      Feature.new available: false
    end
  end
end
