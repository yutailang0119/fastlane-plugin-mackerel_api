module Fastlane
  module Helper
    class MackerelApiHelper
      def self.construct_headers(api_key, overrides)
        require 'base64'
        headers = { 'User-Agent' => 'fastlane-mackerel_api' }
        headers['X-Api-Key'] = Base64.strict_encode64(api_key).to_s if api_key
        headers.merge(overrides || {})
      end

      def self.construct_url(server_url, path, url)
        return_url = (server_url && path) ? File.join(server_url, path) : url
        UI.user_error!("Please provide either `server_url` (e.g. https://api.mackerelio.com) and 'path' or full 'url' for Mackerel API endpoint") unless return_url
        return_url
      end

      def self.construct_body(body, raw_body)
        body ||= {}
        if raw_body
          raw_body
        elsif body.kind_of?(Hash)
          body.to_json
        elsif body.kind_of?(Array)
          body.to_json
        else
          UI.user_error!("Please provide valid JSON, or a hash as request body") unless parse_json(body)
          body
        end
      end

      def self.parse_json(value)
        JSON.parse(value)
      rescue JSON::ParserError
        nil
      end

      def self.call_endpoint(url, http_method, headers, body, secure)
        require 'excon'
        Excon.defaults[:ssl_verify_peer] = secure
        middlewares = Excon.defaults[:middlewares] + [Excon::Middleware::RedirectFollower] # allow redirect in case of repo renames
        UI.verbose("#{http_method} : #{url}")
        connection = Excon.new(url)
        connection.request(
          method: http_method,
          headers: headers,
          middlewares: middlewares,
          body: body,
          debug_request: FastlaneCore::Globals.verbose?,
          debug_response: FastlaneCore::Globals.verbose?
        )
      end
    end
  end
end
