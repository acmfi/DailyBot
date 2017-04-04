defmodule DailyBot do
  use Application
  def start, do: start(1, 1)

  def start(_, _) do
    import Supervisor.Spec

    children = [
      supervisor(Telex, []),
      supervisor(DailyBot.Bot, [:updates, Application.get_env(:daily_bot, :token)]),
      worker(Timer, [])
    ]

    opts = [strategy: :one_for_one, name: DailyBot]
    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        IO.puts "Starting"
        ok
      error ->
        IO.puts "Error"
        error
    end
  end
end
