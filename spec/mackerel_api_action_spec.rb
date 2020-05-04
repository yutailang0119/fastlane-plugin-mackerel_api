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

  describe '#MackerelApiHelper.construct_headers' do
    it 'construct headers' do
      api_key = random_identifier(30)
      headers = Fastlane::Helper::MackerelApiHelper.construct_headers(api_key, nil)

      expect(headers).to eq({
        'User-Agent' => 'fastlane-mackerel_api',
        'X-Api-Key' => api_key
      })
    end

    it 'construct headers with overrides' do
      api_key = random_identifier(30)
      overrides = { 'Foo' => 'bar' }
      headers = Fastlane::Helper::MackerelApiHelper.construct_headers(api_key, overrides)

      expect(headers).to eq({
        'User-Agent' => 'fastlane-mackerel_api',
        'X-Api-Key' => api_key,
        'Foo' => 'bar'
      })
    end

    private

    def random_identifier(number)
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample }.join
    end
  end
end
