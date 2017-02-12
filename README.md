[![Gem Version](https://badge.fury.io/rb/cli_tester.svg)](http://badge.fury.io/rb/cli_tester)
[![Build Status](https://travis-ci.org/cornelius/cli_tester.svg?branch=master)](https://travis-ci.org/cornelius/cli_tester)

CliTester is a simple set of helpers for testing command line interfaces with
RSpec. It provides a method to run command line applications and a way to check
the output and exit codes.

Use it in combination with
[GivenFilesystem](https://github.com/cornelius/given_filesystem) for convenient
testing of command line applications.

CliTester is licensed under the MIT license.

If you have questions or comments, please get in touch with Cornelius Schumacher
<schumacher@kde.org>.

## Usage

To make the helpers of `cli_tester` available in your tests add the `cli_tester` gem to your Gemfile and include the `CliTester` module in your tests, e.g. in your `spec_helper.rb`:

```ruby
require "cli_tester"

include CliTester
```

## Helpers

* `run_command`: Run command with specified arguments
* `exits_with_success`: Check that executable exits with exit code 0
* `exits_with_error`: Check that executable exits with exit code different from 0
