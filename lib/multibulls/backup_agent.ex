defmodule Multibulls.BackupAgent do
    use Agent
    
    # Attribution: Nat Tuck's Multiplayer Hangman Code
    def start_link(_arg) do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
    end
  
    # Attribution: Nat Tuck's Multiplayer Hangman Code
    def put(name, val) do
      Agent.update __MODULE__, fn state ->
        Map.put(state, name, val)
      end
    end
 
    # Attribution: Nat Tuck's Multiplayer Hangman Code
    def get(name) do
      Agent.get __MODULE__, fn state ->
        Map.get(state, name)
      end
    end
  end