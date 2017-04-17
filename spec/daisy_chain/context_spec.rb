module DaisyChain
  describe Context do
    subject = Class.new do
      include DaisyChain::Context
      attributes :foo, :bar
    end

    describe "::build" do
      describe "given nothing" do
        it "builds an empty context" do
          context = subject.build
          expect(context).to be_a DaisyChain::Context
          expect(context.foo).to be_nil
        end
      end

      describe "given a hash" do
        let(:context) { subject.build(context_param) }
        let(:context_param) { { foo: true, bar: true, baz: false } }

        it "creates a context from the hash" do
          expect(context).to be_a DaisyChain::Context
          expect(context.foo).to be true
          expect(context.bar).to be true
          expect { context.baz }.to raise_error NoMethodError
        end

        it "doesn't affect the previous hash" do
          expect(context).to be_a DaisyChain::Context
          expect {
            context.foo = false
          }.not_to change {
            context_param[:foo]
          }
        end
      end

      describe "given a different context" do
        let(:context) { subject.build(context_param) }
        let(:context_param) do
          Class.new do
            include DaisyChain::Context
            attributes :foo, :bar, :baz
          end.new({ foo: true, bar: true, baz: false })
        end

        it "absorbs its attributes" do
          expect(context).to be_a DaisyChain::Context
          expect(context.foo).to be true
          expect(context.bar).to be true
          expect { context.baz }.to raise_error NoMethodError
        end
      end
    end

    describe "#success?" do
      it "is true by default" do
        context = subject.build
        expect(context.success?).to be true
      end
    end

    describe "#failure?" do
      it "is false by default" do
        context = subject.build
        expect(context.failure?).to be false
      end
    end

    describe "#fail!" do
      let(:context) { subject.build(foo: "bar") }

      it "sets success to false" do
        expect {
          context.fail! rescue nil
        }.to change {
          context.success?
        }.from(true).to(false)
      end

      it "sets failure to true" do
        expect {
          context.fail! rescue nil
        }.to change {
          context.failure?
        }.from(false).to(true)
      end

      it "preserves failure" do
        context.fail! rescue nil

        expect {
          context.fail! rescue nil
        }.not_to change {
          context.failure?
        }
      end

      it "preserves the context" do
        expect {
          context.fail! rescue nil
        }.not_to change {
          context.foo
        }
      end

      it "updates the context" do
        expect {
          context.fail!(foo: "baz") rescue nil
        }.to change {
          context.foo
        }.from("bar").to("baz")
      end

      it "raises failure" do
        expect {
          context.fail!
        }.to raise_error(Failure)
      end

      it "makes the context available from the failure" do
        begin
          context.fail!
        rescue Failure => error
          expect(error.context).to eq(context)
        end
      end
    end

    describe "#called!" do
      let(:context) { subject.build }
      let(:instance1) { double(:instance1) }
      let(:instance2) { double(:instance2) }

      it "appends to the internal list of called instances" do
        expect {
          context.called!(instance1)
          context.called!(instance2)
        }.to change {
          context._called
        }.from([]).to([instance1, instance2])
      end
    end

    describe "#rollback!" do
      let(:context) { subject.build }
      let(:instance1) { double(:instance1) }
      let(:instance2) { double(:instance2) }

      before do
        allow(context).to receive(:_called) { [instance1, instance2] }
      end

      it "rolls back each instance in reverse order" do
        expect(instance2).to receive(:rollback).once.with(no_args).ordered
        expect(instance1).to receive(:rollback).once.with(no_args).ordered

        context.rollback!
      end

      it "ignores subsequent attempts" do
        expect(instance2).to receive(:rollback).once
        expect(instance1).to receive(:rollback).once

        context.rollback!
        context.rollback!
      end
    end

    describe "#_called" do
      let(:context) { subject.build }

      it "is empty by default" do
        expect(context._called).to eq([])
      end
    end
  end
end
