module DaisyChain
  class Error < StandardError; end
  class Failure < Error
    def initialize(context = nil)
      @context = context
      super
    end

    attr_reader :context
  end

  class ContractViolation < Error
    def initialize(attributes, context)
      @attributes = attributes
      @context = context
      super(build_message)
    end

    attr_reader :attributes, :context

    private

    def context_class
      @context.class.name
    end

    def build_message
      "Missing the following attributes on #{context_class}: #{attributes.join(', ')}"
    end
  end
end
