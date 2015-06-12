require "cheetah"

class CommandResult
  attr_accessor :stdout, :stderr, :exit_code
end

def run_command(cmd: nil, args: nil)
  if cmd
    cmd = ["bin/" + cmd]
  else
    cmd = ["bin/" + File.basename(Dir.pwd)]
  end

  result = CommandResult.new

  if args
    cmd += args
  end

  begin
    o, e = Cheetah.run(cmd, stdout: :capture, stderr: :capture )
    result.exit_code = 0
    result.stdout = o
    result.stderr = e
  rescue Cheetah::ExecutionFailed => e
    result.exit_code = e.status.exitstatus
    result.stdout = e.stdout
    result.stderr = e.stderr
  end

  result
end
