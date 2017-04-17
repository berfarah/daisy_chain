module DaisyChain
  module Organizer
    def self.included(base)
      base.class_eval do
        include Interactor::Organizer
        include Contract
        include ContextSetter
      end
    end
  end
end
