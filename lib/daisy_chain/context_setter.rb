require_relative "context"

module DaisyChain
  class DefaultContext
    include Context
  end

  module ContextSetter
    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(context = {})
      @context = self.class.context_class.build(context)
    end

    module ClassMethods
      def context(klass)
        @context_class = klass
      end

      def context_class
        @context_class || DefaultContext
      end
    end
  end
end
