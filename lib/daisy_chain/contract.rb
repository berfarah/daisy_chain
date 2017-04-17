module DaisyChain
  module Contract
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        before :validate_contract!
      end
    end

    def validate_contract!
      missing_attributes = self.class.required.reject do |attribute|
        context.respond_to?(attribute) && !context[attribute].nil?
      end
      return if missing_attributes.empty?
      raise ContractViolation.new(missing_attributes, context)
    end

    module ClassMethods
      def requires(*attributes)
        required.concat(attributes)
        provides(*attributes)
      end

      def provides(*attributes)
        define_attributes!(attributes - provided)
        provided.concat(attributes)
      end

      def required
        @required ||= []
      end

      private

      def provided
        @provided ||= []
      end

      def define_attributes!(attributes)
        attributes.each do |attribute|
          define_method(attribute) { context[attribute] }
        end
      end
    end
  end
end
