defmodule Bulls.Game do
    # Initial state of the game
    def new do
      generate_secret()
      %{
        secret: generate_secret(),
        guesses: [],
        scores: [],
        won: false,
        lives: 8,
      }
    end
  
    # Filters out bad guesses, like empty text, and if the guess is valid, the bull and cows scores are calculated
    def guess(st, guess) do  
        if guess == "" do 
          %{
            secret: st.secret,
            guesses: st.guesses,
            scores: st.scores,
            won: false,
            lives: st.lives
        } else 
          won = false
          tokens = String.split(guess, "")
          new_string = Integer.to_string(st.secret)
          secret_tokens = String.split(new_string, "")
          bullsandcows = getvalues(secret_tokens, tokens)  

          # Updating the state values 
          temp = [guess | st.guesses]
          newscores = [bullsandcows | st.scores]
          newlives = st.lives - 1

          # Checking to see if the correct number is inputted first
          if new_string == guess do
            %{
              secret: st.secret,
              guesses: temp,
              scores: st.scores,
              won: true,
              lives: newlives
          }
          else
            %{
              secret: st.secret,
              guesses: temp,
              scores: newscores,
              won: won,
              lives: newlives
          }
          end
        end
    end

    # Gets the bull and cows count for the given guess
    def getvalues(secret, guess) do
      bulls = getbulls(secret, guess, 0) - 1
      cows = getcows(secret, guess, 0) - 1
      temp = []

      temp = [cows | temp]
      [bulls | temp]
    end

    # Gets the number of cows in the guess
    def getcows(secret, guess, acc) do
      if length(guess) == 1 do
        acc
      else 
        [head | tail] = guess

        if Enum.member?(secret, head) do
          getcows(secret, tail, acc = acc + 1)
        else
          getcows(secret, tail, acc)
        end
      end

    end
    
    # Gets the number of bulls in the guess
    def getbulls(secret, guess, acc) do
      if length(secret) == 1 do
        acc
      else
        [head | tail] = secret
        [otherhead | othertail] = guess

        if head == otherhead do
          getbulls(tail, othertail, acc = acc + 1)
        else
          getbulls(tail, othertail, acc)
        end
      end
    end

    # Provides the state to the front-end, but without the secret
    def view(st) do
      %{
        guesses: st.guesses,
        scores: st.scores,
        won: st.won,
        lives: st.lives
      }
    end

    def view(st, name) do
      %{
        guesses: st.guesses,
        scores: st.scores,
        won: st.won,
        lives: st.lives,
        name: name
      }
    end
  
    # Calls the random secret key generator
    def generate_secret() do
      temp = generate_secret_helper([])
      temp
    end

    # Generates a random secret key
    def generate_secret_helper(num) do
      Enum.random(1_000..9_999)
    end
  end