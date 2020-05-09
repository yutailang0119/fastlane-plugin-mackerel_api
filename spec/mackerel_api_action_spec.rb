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
        'Content-Type' => 'application/json',
        'X-Api-Key' => api_key
      })
    end

    it 'construct headers with overrides' do
      api_key = random_identifier(30)
      overrides = { 'Foo' => 'foo' }
      headers = Fastlane::Helper::MackerelApiHelper.construct_headers(api_key, overrides)

      expect(headers).to eq({
        'User-Agent' => 'fastlane-mackerel_api',
        'Content-Type' => 'application/json',
        'X-Api-Key' => api_key,
        'Foo' => 'foo'
      })
    end

    private

    def random_identifier(number)
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample }.join
    end
  end

  describe '#MackerelApiHelper.construct_url' do
    it 'construct url with server_url & path' do
      server_url = 'https://api.mackerelio.com'
      path = 'api/v0/org'
      full_url = 'https://kcps-mackerel.io/api/v0/services'
      url = Fastlane::Helper::MackerelApiHelper.construct_url(server_url, path, full_url)

      expect(url).to eq("#{server_url}/#{path}")
    end

    it 'construct url with full url' do
      server_url = 'https://api.mackerelio.com'
      path = nil
      full_url = 'https://kcps-mackerel.io/api/v0/services'
      url = Fastlane::Helper::MackerelApiHelper.construct_url(server_url, path, full_url)

      expect(url).to eq(full_url)
    end

    it 'construct url with error' do
      expect { Fastlane::Helper::MackerelApiHelper.construct_url(nil, nil, nil) }.to raise_error(FastlaneCore::Interface::FastlaneError)
    end
  end

  describe '#MackerelApiHelper.construct_body' do
    it 'construct body with raw body' do
      raw_body = "{\"Foo\":\"foo\",\"Bar\":\"bar\"}"
      body = Fastlane::Helper::MackerelApiHelper.construct_body(nil, raw_body)

      expect(body).to eq("{\"Foo\":\"foo\",\"Bar\":\"bar\"}")
    end

    it 'construct body with Hash' do
      hash = { 'Foo' => 'foo', 'Bar' => 'bar' }
      body = Fastlane::Helper::MackerelApiHelper.construct_body(hash, nil)

      expect(body).to eq("{\"Foo\":\"foo\",\"Bar\":\"bar\"}")
    end

    it 'construct body with Array' do
      array = ['Foo', 'Bar']
      body = Fastlane::Helper::MackerelApiHelper.construct_body(array, nil)

      expect(body).to eq("[\"Foo\",\"Bar\"]")
    end

    it 'construct body with error' do
      string = 'foobarpiyo'
      expect { Fastlane::Helper::MackerelApiHelper.construct_body(string, nil) }.to raise_error(FastlaneCore::Interface::FastlaneError)
    end
  end

  describe '#MackerelApiHelper.parse_json' do
    it 'parse json' do
      raw_json = "{\"Foo\":\"foo\",\"Bar\":\"bar\"}"
      json = Fastlane::Helper::MackerelApiHelper.parse_json(raw_json)

      expect(json).to eq({ 'Foo' => 'foo', 'Bar' => 'bar' })
    end

    it 'failure parse json' do
      raw_json = ''
      json = Fastlane::Helper::MackerelApiHelper.parse_json(raw_json)

      expect(json).to eq(nil)
    end
  end
end
