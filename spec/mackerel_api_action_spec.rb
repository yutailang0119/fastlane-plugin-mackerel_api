describe Fastlane::Actions::MackerelApiAction do
  describe '#run' do
    it 'call Mackerel API' do
      result = Fastlane::Actions::MackerelApiAction.run(server_url: 'https://api.mackerelio.com',
                                                        path: 'api/v0/org',
                                                        api_key: ENV['FL_MACKEREL_API_KEY'])
      expect(result[:status]).to eq(200)
      expect(result[:body]["name"].nil?).to be(false)
      expect(result[:json].key?("name")).to be(true)
    end
  end
end
