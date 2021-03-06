require 'fastlane/action'
require_relative '../helper/mackerel_api_helper'

module Fastlane
  module Actions
    module SharedValues
      MACKEREL_API_STATUS_CODE = :MACKEREL_API_STATUS_CODE
      MACKEREL_API_RESPONSE = :MACKEREL_API_RESPONSE
      MACKEREL_API_JSON = :MACKEREL_API_JSON
    end

    class MackerelApiAction < Action
      def self.run(params)
        require 'json'

        http_method = (params[:http_method] || 'GET').to_s.upcase
        url = Helper::MackerelApiHelper.construct_url(params[:server_url], params[:path], params[:url])
        headers = Helper::MackerelApiHelper.construct_headers(params[:api_key], params[:headers])
        payload = Helper::MackerelApiHelper.construct_body(params[:body], params[:raw_body])
        error_handlers = params[:error_handlers] || {}
        secure = params[:secure]

        response = Helper::MackerelApiHelper.call_endpoint(
          url,
          http_method,
          headers,
          payload,
          secure
        )

        status_code = response[:status]
        result = {
          status: status_code,
          body: response.body || "",
          json: Helper::MackerelApiHelper.parse_json(response.body) || {}
        }

        if status_code.between?(200, 299)
          UI.verbose("Response:")
          UI.verbose(response.body)
          UI.verbose("---")
          yield(result) if block_given?
        else
          handled_error = error_handlers[status_code] || error_handlers['*']
          if handled_error
            handled_error.call(result)
          else
            UI.error("---")
            UI.error("Request failed:\n#{http_method}: #{url}")
            UI.error("Headers:\n#{headers.map { |key, value| key == 'X-Api-Key' ? ['X-Api-Key', '********'] : [key, value] }.to_h}")
            UI.error("---")
            UI.error("Response:")
            UI.error(response.body)
            UI.user_error!("Mackerel responded with #{status_code}\n---\n#{response.body}")
          end
        end

        Actions.lane_context[SharedValues::MACKEREL_API_STATUS_CODE] = result[:status]
        Actions.lane_context[SharedValues::MACKEREL_API_RESPONSE] = result[:body]
        Actions.lane_context[SharedValues::MACKEREL_API_JSON] = result[:json]

        return result
      end

      def self.description
        "Call a Mackerel API endpoint and get the resulting JSON response"
      end

      def self.details
        [
          "Call a [Mackerel](https://mackerel.io) API endpoint and get the resulting JSON response.",
          "You must provide your Mackerel API key (get one from [Dashboard](https://mackerel.io/my?tab=apikeys)).",
          "Documentation: [Mackerel API Documents](https://mackerel.io/api-docs)."
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :server_url,
                                       env_name: "FL_MACKEREL_API_SERVER_URL",
                                       description: "The server url. e.g. 'https://api.mackerelio.com'",
                                       default_value: "https://api.mackerelio.com",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please include the protocol in the server url, e.g. https://api.mackerelio.com") unless value.include?("//")
                                       end),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "FL_MACKEREL_API_KEY",
                                       description: "API key for Mackerel - generate one at https://mackerel.io/my?tab=apikeys",
                                       sensitive: true,
                                       code_gen_sensitive: true,
                                       is_string: true,
                                       default_value: ENV["MACKEREL_API_KEY"],
                                       default_value_dynamic: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :http_method,
                                       env_name: "FL_MACKEREL_API_HTTP_METHOD",
                                       description: "The HTTP method. e.g. GET / POST",
                                       default_value: "GET",
                                       optional: true,
                                       verify_block: proc do |value|
                                         unless %w(GET POST PUT DELETE HEAD CONNECT PATCH).include?(value.to_s.upcase)
                                           UI.user_error!("Unrecognised HTTP method")
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :body,
                                       env_name: "FL_MACKEREL_API_REQUEST_BODY",
                                       description: "The request body in JSON or hash format",
                                       is_string: false,
                                       default_value: {},
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :raw_body,
                                       env_name: "FL_MACKEREL_API_REQUEST_RAW_BODY",
                                       description: "The request body taken verbatim instead of as JSON, useful for file uploads",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "FL_MACKEREL_API_PATH",
                                       description: "The endpoint path. e.g. '/api/v0/hosts/<hostId>/metadata/<namespace>'",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "FL_MACKEREL_API_URL",
                                       description: "The complete full url - used instead of path. e.g. 'https://api.mackerelio.com/api/v0/services'",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please include the protocol in the url, e.g. https://api.mackerelio.com") unless value.include?("//")
                                       end),
          FastlaneCore::ConfigItem.new(key: :error_handlers,
                                       description: "Optional error handling hash based on status code, or pass '*' to handle all errors",
                                       is_string: false,
                                       default_value: {},
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :headers,
                                       description: "Optional headers to apply",
                                       is_string: false,
                                       default_value: {},
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :secure,
                                       env_name: "FL_MACKEREL_API_SECURE",
                                       description: "Optionally disable secure requests (ssl_verify_peer)",
                                       type: Boolean,
                                       default_value: true,
                                       optional: true)
        ]
      end

      def self.output
        [
          ['MACKEREL_API_STATUS_CODE', 'The status code returned from the request'],
          ['MACKEREL_API_RESPONSE', 'The full response body'],
          ['MACKEREL_API_JSON', 'The parsed json returned from Mackerel']
        ]
      end

      def self.return_value
        "A hash including the HTTP status code (:status), the response body (:body), and if valid JSON has been returned the parsed JSON (:json)."
      end

      def example_code
        [
          'result = mackerel_api(
            server_url: "https://api.mackerelio.com",
            api_key: ENV["MACKEREL_API_KEY"],
            http_method: "POST",
            path: "api/v0/services",
            body: { "name": "ExampleService", "memo": "This is an example." }
          )',
          '# Alternatively call directly with optional error handling or block usage
          MackerelApiAction.run(
            server_url: "https://api.mackerelio.com",
            api_key: ENV["MACKEREL_API_KEY"],
            http_method: "POST",
            path: "api/v0/services",
            error_handlers: {
              404 => proc do |result|
                UI.message("Something went wrong - I couldn\'t find it...")
              end,
              \'*\' => proc do |result|
                UI.message("Handle all error codes other than 404")
              end
            }
          ) do |result|
            UI.message("JSON returned: #{result[:json]}")
          end
          '
        ]
      end

      def self.authors
        ["yutailang0119"]
      end

      def self.is_supported?(platform)
        true
      end

      def category
        :source_control
      end
    end
  end
end
