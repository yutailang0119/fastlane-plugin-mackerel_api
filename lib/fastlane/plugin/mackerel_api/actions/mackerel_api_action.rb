require 'fastlane/action'
require_relative '../helper/mackerel_api_helper'

module Fastlane
  module Actions
    class MackerelApiAction < Action
      def self.run(params)
        UI.message("The mackerel_api plugin is working!")
      end

      def self.description
        "Call a Mackerel API endpoint and get the resulting JSON response"
      end

      def self.authors
        ["yutailang0119"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        [
          "Calls any Mackerel API endpoint.",
          "Documentation: [https://mackerel.io/api-docs/](https://mackerel.io/api-docs/)."
        ].join("\n")
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "MACKEREL_API_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
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
