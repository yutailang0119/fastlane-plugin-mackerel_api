describe Fastlane::Actions::MackerelApiAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The mackerel_api plugin is working!")

      Fastlane::Actions::MackerelApiAction.run(nil)
    end
  end
end
