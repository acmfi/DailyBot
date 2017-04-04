defmodule DailyBot.Bot do
  @bot :daily_bot
  def bot(), do: @bot

  use Telex.Bot, name: @bot
  use Telex.Dsl

  def handle({:command, "start", %{text: t} = msg}, name, _) do
    Timer.start_link
    answer msg, "_Hello there!_\nReady for the daily spam?\nTomorrow at 9:00am I will send you your *TODO* list.", bot: name, parse_mode: "Markdown"
  end

  def handle({:command, "todo", msg}, name, _) do
    answer msg, GenServer.call(:timer, :todo), bot: name, parse_mode: "Markdown"
  end

  def handle({:command, "add", %{text: t} = msg}, name, _) do
    answer msg, GenServer.call(:timer, {:add, t}), bot: name, parse_mode: "Markdown"
  end

  def handle({:command, "remove", %{text: t} = msg}, name, _) do
    answer msg, GenServer.call(:timer, {:remove, t}), bot: name, parse_mode: "Markdown"
  end

  # Listener
  def handle({_, _, %{text: t, from: %{username: user}}}, _) when not is_nil(user) do
    [:hotpink, "[LISTENER] @#{user} -> #{t}"]
    |> Bunt.puts
  end

  def handle({_, _, %{text: t, from: %{first_name: user}}}, _) do
    [:hotpink, "[LISTENER] @#{user} -> #{t}"]
    |> Bunt.puts
  end
end
