# Attribution: Nat Tuck's Multiplayer Hangman Code
defmodule Multibulls.GameServer do 
    use GenServer
    
    alias Multibulls.BackupAgent
    alias Bulls.Game

    # Public Interface
    def reg(name) do
        {:via, Registry, {Multibulls.GameReg, name}}
    end

    def start(name) do 
        spec = %{
            id: __MODULE__,
            start: {__MODULE__, :start_link, [name]},
            restart: :permanent,
            type: :worker
          }
          IO.puts(name)
          Multibulls.GameSup.start_child(spec)
    end

    def reset(name) do
        GenServer.call(reg(name), {:reset, name})
    end

    def guess(name, guess) do
        GenServer.call(reg(name), {:guess, name, guess})
    end

    def peek(name) do
        GenServer.call(reg(name), {:peek, name})
    end

    # Implementation:
    def init(game) do
        {:ok, game}
    end

    def handle_call({:reset, name}, _from, game) do
        game = Game.new
        BackupAgent.put(name, game)
        {:reply, game, game}
    end

    def handle_call({:guess, name, guess}, _from, game) do
        game = Game.guess(game, guess)
        BackupAgent.put(name, game)
        {:reply, game, game}
    end

    def handle_call({:peek, _name}, _from, game) do
        {:reply, game, game}
    end
end

