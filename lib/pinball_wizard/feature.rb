require 'pinball_wizard/helpers/hash'

module PinballWizard
  class Feature
    attr_reader :name, :active, :available, :options

    def initialize(name, *options)
      @name      = name
      options    = Helpers::Hash.normalize_options(options)
      @active    = ensure_callable(options.fetch(:active, false))
      @available = ensure_callable(options.fetch(:available, true))
      @options   = Helpers::Hash.without(options, :name, :active, :available)
    end

    def active?
      active.call
    end

    def available?
      available.call
    end

    def to_h
      {
        active:    active?,
        available: available?
      }
    end

    alias_method :to_hash, :to_h

    private

    def ensure_callable(object)
      object.respond_to?(:call) ? object : proc { object }
    end
  end
end
