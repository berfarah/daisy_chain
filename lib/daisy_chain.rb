require "interactor"
require "daisy_chain/version"
require "daisy_chain/contract"
require "daisy_chain/context_setter"
require "daisy_chain/organizer"

module DaisyChain
  def self.included(base)
    base.class_eval do
      include Interactor
      include Contract
      include ContextSetter
    end
  end
end
