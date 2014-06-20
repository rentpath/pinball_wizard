require 'pinball/helpers/string'

module Pinball
  module Feature
    module ClassMethods

      def available(value = true, &block)
        @available = block.nil? ? proc { !!value } : block
      end

      def available?
        @available.call
      end

      def active_by_default(value = false, &block)
        @active_by_default = block.nil? ? proc { !!value } : block
      end

      def active_by_default?
        @active_by_default.call
      end

      def registry_name
        Helpers::String.underscore(name).gsub('_feature','')
      end

      def to_h
        {
          available:         available?,
          active_by_default: active_by_default?
        }
      end

      alias_method :to_hash, :to_h

      def set_defaults
        available true
        active_by_default false
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.set_defaults
    end
  end
end
