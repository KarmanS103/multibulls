defmodule MultiBullsWeb.GameChannel do
  use MultibullsWeb, :channel

  alias Bulls.Game
  alias Multibulls.GameServer

  # Handling the user joining the channel
  # Attribution: Nat Tuck's Lecture 8 Code

  @impl true
  def join("game:" <> name, payload, socket) do
    if authorized?(payload) do
      GameServer.start(name)
      socket = socket
      |> assign(:name, name)
      |> assign(:user, "")
      game = GameServer.peek(name)
      view = Game.view(game, "")
      {:ok, view, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # @impl true
  # def join("game:" <> name, payload, socket) do
  #   if authorized?(payload) do
  #     GameServer.start(name)
  #     socket = socket
  #     |> assign(:name, name)
  #     |> assign(:user, "")
  #     game = GameServer.peek(name)
  #     view = Game.view(game, "")
  #     {:ok, view, socket}

  #     # game = Game.new
  #     # socket = assign(socket, :game, game)
  #     # view = Game.view(game)
  #     # {:ok, view, socket}
  #   else
  #     {:error, %{reason: "unauthorized"}}
  #   end
  # end

  # Handling a user logging in
  # Attribution: Nat Tuck's Lecture 8 Code
  @impl true
  def handle_in("login", %{"name" => user}, socket) do
    socket = assign(socket, :user, user)
    view = socket.assigns[:name]
    |> GameServer.peek()
    |> Game.view(user)
    {:reply, {:ok, view}, socket}
  end

  # Handling the guess input from the user
  # Attribution: Nat Tuck's Lecture 8 Code
  @impl true
  def handle_in("guess", %{"guess" => gs}, socket) do
    user = socket.assigns[:user]
    view = socket.assigns[:name]
    |> GameServer.guess(gs)
    |> Game.view(user)
    # broadcast(socket, "view", view)
    # game0 = socket.assigns[:game]
    # game1 = Bulls.Game.guess(game0, gs)
    # socket = assign(socket, :game, game1)
    # view = Bulls.Game.view(game1)
    {:reply, {:ok, view}, socket}
  end

  # Handling the reset call from the user
  # Attribution: Nat Tuck's Lecture 8 Code
  @impl true
  def handle_in("reset", _, socket) do
    game = Game.new
    socket = assign(socket, :game, game)
    view = Game.view(game)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_out("view", msg, socket) do
    user = socket.assigns[:user]
    msg = %{msg | name: user}
    push(socket, "view", msg)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
