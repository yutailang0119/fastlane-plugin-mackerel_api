require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class MackerelApiHelper
      # class methods that you define here become available in your action
      # as `Helper::MackerelApiHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the mackerel_api plugin helper!")
      end
    end
  end
end
