require 'pinball_wizard/helpers/hash'

# Further Reading: https://practicingruby.com/articles/ruby-and-the-singleton-pattern-dont-get-along
module PinballWizard
  module Registry
    extend self

    def add(feature)
      collection[feature.registry_name] = feature
    end

    def available?(name)
      feature = collection.fetch(name, NullFeature)
      feature.available?
    end

    def collection
      @collection ||= {}
    end

    def clear
      @collection = {}
    end

    def to_json
      Helpers::Hash.camelize_hash_keys(collection)
    end
  end
end
