require_relative "spec_helper"

describe "Command line interface" do
  describe "help" do
    it "shows help when run with no args" do
      result = run_command
      expect(result.exit_code).to eq(0)
      expect(result.stdout).to match(/Commands:/)
      expect(result.stderr.empty?).to be(true)
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
      result = run_command(args: ["list"])
      expect(result.exit_code).to eq(0)
      expect(result.stdout).to eq("one\ntwo\n")
      expect(result.stderr.empty?).to be(true)
    end
  end
end

describe "options" do
  it "runs specified cmd" do
    result = run_command(cmd: "the_other_one")
    expect(result.stdout).to eq("I'm the other one\n")
  end
end
