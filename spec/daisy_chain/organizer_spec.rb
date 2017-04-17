describe DaisyChain::Organizer do
  subject { Class.new { include DaisyChain::Organizer } }

  it "is a Interactor::Organizer" do
    expect(subject.new).to be_a(Interactor::Organizer)
  end
end
