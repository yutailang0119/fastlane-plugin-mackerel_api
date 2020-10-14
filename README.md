# mackerel_api plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-mackerel_api)
[![Test](https://github.com/yutailang0119/fastlane-plugin-mackerel_api/workflows/Test/badge.svg)](https://github.com/yutailang0119/fastlane-plugin-mackerel_api/actions?query=branch%3Amaster+workflow%3ATest)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-mackerel_api`, add it to your project by running:

```bash
fastlane add_plugin mackerel_api
```

## About mackerel_api

Call a [Mackerel](https://mackerel.io) API endpoint and get the resulting JSON response.

Documentation: [Mackerel API Documents](https://mackerel.io/api-docs).

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

See [MackerelApiAction](lib/fastlane/plugin/mackerel_api/actions/mackerel_api_action.rb).example_code for more usage.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
