module DaisyChain
  describe ContextSetter do
    context_class = Class.new do
      include Context
      attributes :foo, :bar
    end

    unmodified_interactor = Class.new do
      include Interactor
      include ContextSetter
    end

    modified_interactor = Class.new do
      include Interactor
      include ContextSetter
      context context_class
    end

    unmodified_organizer = Class.new do
      include Interactor::Organizer
      include ContextSetter
    end

    modified_organizer = Class.new do
      include Interactor::Organizer
      include ContextSetter
      context context_class
    end

    describe "when the context isn't overwritten" do
      it "defaults to DefaultContext" do
        expect(unmodified_interactor.call).to be_a(DefaultContext)
        expect(unmodified_organizer.call).to be_a(DefaultContext)
      end
    end

    describe "::context" do
      it "overrides the context" do
        expect(modified_interactor.call).to be_a(context_class)
        expect(modified_organizer.call).to be_a(context_class)
      end
    end
  end
end
