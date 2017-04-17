module DaisyChain
  describe Contract do
    describe "::requires" do
      let(:interactor) do
        Class.new do
          include Interactor
          include Contract
          requires :foo

          def call
            foo
          end
        end
      end
      describe "when the required fields aren't passed in" do
        it "raises an error" do
          expect { interactor.call }.to raise_error(ContractViolation)
        end
      end

      describe "when the required fields are passed in" do
        describe "and they're nil" do
          it "raises an error" do
            expect { interactor.call(foo: nil) }.to raise_error(ContractViolation)
          end
        end

        describe "and they're present" do
          it "succeeds" do
            expect { interactor.call(foo: true) }.not_to raise_error
          end

          it "defines methods for those attributes" do
            subject = interactor.new(foo: true)
            expect(subject.foo).to be true
          end
        end
      end
    end

    describe "::provides" do
      let(:interactor) do
        Class.new do
          include Interactor
          include Contract
          provides :bar
        end
      end

      it "defines methods for provided attributes" do
        subject = interactor.new(bar: true)
        expect(subject.bar).to be true
      end

      it "doesn't care if provided attributes are missing" do
        expect { interactor.call }.not_to raise_error
        expect { interactor.call(bar: nil) }.not_to raise_error
      end
    end
  end
end
