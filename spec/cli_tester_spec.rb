require_relative "spec_helper"

include CliTester
include GivenFilesystemSpecHelpers

describe "Command line interface" do
  describe "help" do
    it "shows help when run with no args" do
      expect(run_command).to exit_with_success(/Commands:/)
    end

    it "shows help when run with help command" do
      result = run_command(args: ["help"])
      expect(result.exit_code).to eq(0)
      expect(result.stdout).to match(/Commands:/)
      expect(result.stderr.empty?).to be(true)
    end

    it "shows help when run with --help option" do
      result = run_command(args: ["--help"])
      expect(result.exit_code).to eq(0)
      expect(result.stdout).to match(/Commands:/)
      expect(result.stderr.empty?).to be(true)
    end

    it "shows help for command" do
      result = run_command(args: ["help", "list"])
      expect(result.exit_code).to eq(0)
      expect(result.stdout).to match(/inqlude list/)
      expect(result.stderr.empty?).to be(true)
    end
  end

  describe "errors" do
    it "fails with unknown option" do
      result = run_command(args: ["--xxx"])
      expect(result.exit_code).to eq(0)
      expect(result.stderr).to match(/Unknown/)
    end
  end

  describe "list" do
    it "lists libraries" do
      expect(run_command(args: ["list"])).to exit_with_success("one\ntwo\n")
    end
  end
end

describe "options" do
  use_given_filesystem

  it "runs local cmd" do
    result = run_command(cmd: "the_other_one")
    expect(result.stdout).to eq("I'm the other one\n")
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
    expect(result.stdout).to eq(".\n..\nhello\n")
  end
end
