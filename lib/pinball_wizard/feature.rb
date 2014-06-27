require 'pinball_wizard/helpers/string'

module PinballWizard
  module Feature
    module ClassMethods

      def available(value = true, &block)
        @available = block.nil? ? proc { !!value } : block
      end

      def available?
        @available.call
      end

      def activate_immediately(value = false, &block)
        @activate_immediately = block.nil? ? proc { !!value } : block
      end

      def activate_immediately?
        @activate_immediately.call
      end

      def registry_name
        Helpers::String.underscore(name).gsub('_feature','')
      end

      def to_h
        {
          available:            available?,
          activate_immediately: activate_immediately?
        }
      end

      alias_method :to_hash, :to_h

      def set_defaults
        available true
        activate_immediately false
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.set_defaults
    end
  end
end
