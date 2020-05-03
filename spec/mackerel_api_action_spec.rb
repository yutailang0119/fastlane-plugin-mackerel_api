describe Fastlane::Actions::MackerelApiAction do
  describe '#run' do
    it 'prints a message' do
      # expect(Fastlane::UI).to receive(:message).with("The mackerel_api plugin is working!")

      Fastlane::Actions::MackerelApiAction.run(server_url: 'https://api.mackerelio.com',
                                               path: 'api/v0/services',
                                               api_key: ENV['FL_MACKEREL_API_KEY'])
    end
  end
end
