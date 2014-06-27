require 'pinball_wizard/helpers/hash'

module PinballWizard
  class Feature
    attr_reader :name, :activate_immediately, :available, :options

    def initialize(name, *options)
      @name                 = name
      options               = Helpers::Hash.normalize_options(options)
      @activate_immediately = ensure_callable(options.fetch(:activate_immediately, false))
      @available            = ensure_callable(options.fetch(:available, true))
      @options              = Helpers::Hash.without(options, :name, :activate_immediately, :available)
    end

    def available?
      available.call
    end

    def activate_immediately?
      activate_immediately.call
    end

    def to_h
      {
        available:            available?,
        activate_immediately: activate_immediately?
      }
    end

    alias_method :to_hash, :to_h

    private

    def ensure_callable(object)
      object.respond_to?(:call) ? object : proc { object }
    end
  end
end
