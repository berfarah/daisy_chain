require_relative "errors"

module DaisyChain
  module Context
    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    def initialize(attributes = {})
      @attributes = {}.merge!(attributes.to_h)
    end

    def [](key)
      @attributes[key]
    end

    def success?
      !failure?
    end

    def failure?
      @failure || false
    end

    def fail!(context = {})
      @attributes.merge!(context)
      @failure = true
      raise Failure, self
    end

    def called!(interactor)
      _called << interactor
    end

    def rollback!
      return false if @rolled_back
      _called.reverse_each(&:rollback)
      @rolled_back = true
    end

    def _called
      @called ||= []
    end

    def to_h
      @attributes
    end

    module ClassMethods
      def build(context = {})
        self === context ? context : new(context)
      end

      def attributes(*attributes)
        class_exec(attributes) do |attribute|
          attributes.each do |attribute|
            define_method(attribute) { @attributes[attribute] }
            define_method("#{attribute}=") { |value| @attributes[attribute] = value }
          end
        end
      end
    end
  end
end
