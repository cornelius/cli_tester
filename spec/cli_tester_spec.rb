require_relative "spec_helper"

include CliTester
include GivenFilesystemSpecHelpers

describe "Command line interface" do
  describe "help" do
    it "shows help when run with no args" do
      expect(run_command).to exit_with_success(/Commands:/)
    end

    it "shows help when run with help command" do
      expect(run_command(args: ["help"])).to exit_with_success(/Commands:/)
    end

    it "shows help when run with --help option" do
      expect(run_command(args: ["--help"])).to exit_with_success(/Commands:/)
    end

    it "shows help for command" do
      expect(run_command(args: ["help", "list"])).to exit_with_success(/inqlude list/)
    end
  end

  describe "errors" do
    it "fails with unknown option" do
      expect(run_command(args: ["--xxx"])).to exit_with_success("", /Unknown/)
    end

    it "fails with error" do
      expect(run_command(args: ["fail"])).to exit_with_error(1, "failed\n")
    end
  end

  describe "list" do
    it "lists libraries" do
      expect(run_command(args: ["list"])).to exit_with_success("one\ntwo\n")
    end
  end
end

describe "matchers" do
  describe "exit_with_error" do
    it "fails when stdout does not match" do
      expect {
        expect(run_command(args: ["fail"])).to exit_with_error(1, "failed\n", "wrong")
      }.to raise_error RSpec::Expectations::ExpectationNotMetError
    end

    it "passes when stdout does match" do
      expect(run_command(args: ["fail"])).to exit_with_error(1, "failed\n", "right\n")
    end
  end
end

describe "options" do
  use_given_filesystem

  it "runs local cmd" do
    result = run_command(cmd: "the_other_one")
    expect(result).to exit_with_success("I'm the other one\n")
  end

  it "runs global cmd in specified working directory" do
    dir = given_directory do
      given_dummy_file("hello")
    end
    result = run_command(cmd: "ls", working_directory: dir)
    expect(result).to exit_with_success("hello\n")
  end

  it "runs local cmd in specified working directory" do
    dir = given_directory do
      given_dummy_file("hello")
    end
    result = run_command(args: ["ls"], working_directory: dir)
    expect(result).to exit_with_success(".\n..\nhello\n")
  end
end
