# Copyright (c) 2015 Cornelius Schumacher <schumacher@kde.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "cheetah"

module CliTester
  def self.included(example_group)
    example_group.extend(self)
  end

  class CommandResult
    attr_accessor :stdout, :stderr, :exit_code, :cmd, :error
  end

  def run_command(cmd: nil, args: nil, working_directory: nil)
    if cmd
      path = "bin/" + cmd
    else
      path = "bin/" + File.basename(Dir.pwd)
    end
    if !File.exist?(path)
      executable = [cmd]
    else
      executable = [File.expand_path(path)]
    end

    if args
      executable += args
    end

    if working_directory
      current_working_directory = Dir.pwd
      Dir.chdir(working_directory)
    end

    result = CommandResult.new
    result.cmd = executable
    begin
      o, e = Cheetah.run(executable, stdout: :capture, stderr: :capture )
      result.exit_code = 0
      result.stdout = o
      result.stderr = e
    rescue Cheetah::ExecutionFailed => e
      result.error = e
      result.exit_code = e.status.exitstatus
      result.stdout = e.stdout
      result.stderr = e.stderr
    end

    if working_directory
      Dir.chdir(current_working_directory)
    end

    result
  end
end

RSpec::Matchers.define :exit_with_success do |expected|
  match do |actual|
    return false if actual.exit_code != 0
    return false if !actual.stderr.empty?
    if expected[:stdout]
      return expected[:stdout] == actual.stdout
    else
      return true
    end
  end

  failure_message do |actual|
    message = "ran #{actual.cmd}\n"
    message += "error message: #{actual.error}\n"
    if actual.exit_code != 0
      message += "expected exit code to be zero (was #{actual.exit_code})\n"
    end
    if !actual.stderr.empty?
      message += "expected stderr to be empty (was '#{actual.stderr}')"
    end
    message
  end
end
