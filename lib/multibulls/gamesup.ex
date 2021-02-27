defmodule Multibulls.GameSup do
    use DynamicSupervisor
  
    # Attribution: Nat Tuck's Multiplayer Hangman Code
    def start_link(arg) do
      DynamicSupervisor.start_link(
        __MODULE__,
        arg,
        name: __MODULE__
      )
    end
  
    # Attribution: Nat Tuck's Multiplayer Hangman Code
    @impl true
    def init(_arg) do
      {:ok, _} = Registry.start_link(
        keys: :unique,
        name: Multibulls.GameReg,
      )
      DynamicSupervisor.init(strategy: :one_for_one)
    end
  
    # Attribution: Nat Tuck's Multiplayer Hangman Code
    def start_child(spec) do
      DynamicSupervisor.start_child(__MODULE__, spec)
    end
  
  end