defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias Pento.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok, assign(socket, score: 0, message: "Make a guess:", answer: :rand.uniform(10))}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    IO.inspect(socket.assigns)

    {message, score, answer} =
      cond do
        socket.assigns.answer == to_string(guess) |> String.to_integer() ->
          {
            "Correct! Try again for more points.",
            socket.assigns.score + 1,
            :rand.uniform(10)
          }

        true ->
          {
            "Your guess: #{guess}. Wrong. Guess again.",
            socket.assigns.score - 1,
            socket.assigns.answer
          }
      end

    IO.inspect({message, score, answer})

    {
      :noreply,
      assign(socket, message: message, score: score, answer: answer)
    }
  end

  def time(), do: DateTime.utc_now() |> to_string()

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Your score: {@score}</h1>
    <h2>
      {@message}
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          {n}
        </.link>
      <% end %>
    </h2>
    """
  end
end
