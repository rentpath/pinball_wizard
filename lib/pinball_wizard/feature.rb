require 'pinball_wizard/helpers/hash'

module PinballWizard
  class Feature
    attr_reader :name, :active, :options
    attr_reader :disabled, :message

    def initialize(name, options = {})
      @name      = name.to_s
      @options   = options
      @active    = ensure_callable(options.fetch(:active, false))
      @options   = Helpers::Hash.without(options, :name, :active)
      @disabled  = false
    end

    alias_method :to_s, :name

    def active?
      active.call
    end

    def disabled?
      determine_state # Called here for Registry#disabled?
      disabled
    end

    def disable(message = 'No reason given.')
      @disabled = true
      @message = message
    end

    def determine_state
      # noop: use defaults
    end

    def state
      if disabled?
        "disabled: #{message}"
      elsif active?
        'active'
      else
        'inactive'
      end
    end

    private

    def ensure_callable(object)
      object.respond_to?(:call) ? object : proc { object }
    end
  end
end
