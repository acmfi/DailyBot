defmodule Timer do
  use GenServer

  def start_link do
    GenServer.start_link __MODULE__, :ok, [name: :timer]
  end

  def init(:ok) do
    timer(self())
    Bunt.puts "Running..."
    {:ok, []}
  end

  def timer(pid) do
    timeout = millis_to_next_day()

    Process.send_after pid, :todo, timeout
  end

  defp millis_to_next_day do
    now = Timex.now("Europe/Madrid")
    tomorrow = Timex.shift(Timex.beginning_of_day(now), days: 1, hours: 9)
    Timex.diff(tomorrow, now, :milliseconds)
  end

  defp send_message(text), do: Telex.send_message 14977303, text, bot: :daily_bot

  def format_line(line), do: "  - #{line}"

  def format_todo_list(list) do
    list |> Enum.map(&format_line/1) |> (fn x -> Enum.join(x, "\n") end).()
  end

  def handle_info(:todo, state) do
    todoList = format_todo_list(state)

    send_message "Well hello!\nToday's *TODO* list is: \n#{todoList}"
    timer(self())
  end

  def handle_call(:todo, _, state) do
    todoList = format_todo_list(state)

    {:reply, "*Here you go:*\n#{todoList}", state}
  end

  def handle_call({:remove, elem}, _, state) do
    {:reply, "#{elem} *removed*", List.delete(state, elem)}
  end

  def handle_call({:add, elem}, _, state) do
    {:reply, "#{elem} *added*", [elem | state]}
  end
end
