defmodule Credo.DiffTest do
  use Credo.Test.Case

  @moduletag slow: :integration
  @moduletag timeout: 300_000

  @fixture_integration_bare_repo "test/fixtures/integration_diff_bare_repo"
  @fixture_integration_cloned_repo "test/fixtures/integration_diff_cloned_repo"

  setup do
    if File.exists?(@fixture_integration_cloned_repo) do
      File.rm_rf!(@fixture_integration_cloned_repo)
    end

    {_, 0} =
      System.cmd(
        "git",
        [
          "clone",
          @fixture_integration_bare_repo,
          @fixture_integration_cloned_repo
        ],
        stderr_to_stdout: true
      )

    :ok
  end

  defp checkout(git_ref) do
    {_, 0} =
      System.cmd(
        "git",
        [
          "checkout",
          git_ref
        ],
        cd: @fixture_integration_cloned_repo,
        stderr_to_stdout: true
      )
  end

  test "it should NOT report issues on --help" do
    exec = Credo.run(["diff", "--help"])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should NOT report issues on fixture" do
    exec = Credo.run(["diff", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should NOT report issues on fixture (using --debug)" do
    exec = Credo.run(["diff", "--debug", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should halt on fixture (using --foo)" do
    exec = Credo.run(["diff", "--foo"])

    assert exec.halted == true
  end

  test "it should NOT report issues on fixture (using --strict)" do
    exec = Credo.run(["diff", "--strict", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should NOT report issues using diff command" do
    exec = Credo.run(["diff", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should NOT report issues using diff command (using --strict)" do
    exec = Credo.run(["diff", "--strict", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should report issues using diff command (using --all)" do
    exec = Credo.run(["diff", "--all", "module", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues != []
  end

  test "it should NOT report issues using diff command (using --only)" do
    exec = Credo.run(["diff", "--only", "module", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should NOT report issues using diff command (using --ignore)" do
    exec = Credo.run(["diff", "--ignore", "module", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end

  test "it should NOT report issues using diff command (using --format json)" do
    exec = Credo.run(["diff", "--format", "json", @fixture_integration_cloned_repo])
    issues = Credo.Execution.get_issues(exec)

    assert exec.cli_options.command == "diff"
    assert issues == []
  end
end
