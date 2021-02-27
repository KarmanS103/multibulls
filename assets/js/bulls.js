import React, { useState, useEffect } from 'react';
import { ch_push, ch_join, ch_reset, ch_login } from './socket';

/**
 * Pieces of this code were based on the logic described in Professor Tuck's Lecture 4 and 5 code as 
 * well as the official React and MDN Documentation.
 */

/**
 * Design Decisions: 
 * Once 4 characters are inputted, the guess must be submitted.
 * Invalid guesses do not affect the number of lives. 
 * Guesses less than 4 characters, but greater than 0 adversely affect the score.
 * Players enter 0 to be considered players or 1 if they want to be observers
 * 
 */

/**
 * Given the list of guesses, calculates the bull and cow score and adds the guess and score
 * to the table of guesses and corresponding results. 
 * Attribution: Nat Tuck's Hangman Code. 
 * 
 * @param {*} guesses all of the valid guesses inputted by the user
 */
function Guesses(guesses, scores) {
  let clean_guesess = guesses["guesses"]
  let clean_values = guesses["scores"]

  let double = []
  for (let i = 0; i < clean_guesess.length; i++) {
    double.push(<tr>
      <td>
        {clean_guesess[i]}
      </td>
      <td>
        {clean_values[i][0]} Bulls
        {clean_values[i][1]} Cows
      </td>
    </tr>)
  }

  return (
    <table>
      <thead>
        <tr>
          <th>Guess</th>
          <th>Result</th>
        </tr>
      </thead>
      <tbody>
        {double}
      </tbody>
    </table>
  )
}

function Bulls() {
  const [text, setText] = useState("");
  const [state, setState] = useState({
    guesses: [],
    scores: [],
    won: false,
    lives: 8,
    player: false,
    username: ""
  })


  /**
   * Callback for updating the state when the server sends a new one
   */
  useEffect(() => {
    ch_join(setState);
  });


  function guess() {
    ch_push({ "guess": text })
    setText("")
  }

  /**
   * Based on Nat Tuck's Hangman Code.
   */
  function updateText(ev) {
    let txt = ev.target.value;

    if (text.length >= 4) {
      return
    } else {
      setText(txt)
    }
  }

  /**
   * Attribution: Nat Tuck's Hangman Code. 
   * 
   * @param {*} ev keyPressed Event
   */
  function keyPressed(ev) {
    if (ev.key === "Enter") {
      guess();
    }
  }

  function reset() {
    ch_reset()
    setText("")
  }

  /**
   * Attribution: Nat Tuck's Lecture 9 Code
   */
  if (state["username"] === "") {
    ch_login(state["username"])
    return (
      <div>
        <h1> Login </h1>
        <p>Enter Name:</p>
        <input type="text" value="" />
        <p>Enter Game Name:</p>
        <input type="text" value="" />
        <p>Do you want to be a player? Enter 0 for yes</p>
        <input type="text" value="" />
      </div>
    );

  } else {
    /**
     * Displays a different page depending on if the user won, lost, or is still playing
     */
    if (state["won"]) {
      return (
        <div className="App">
          <h1>You win!</h1>
          <button onClick={reset}>Reset</button>
        </div>
      );
    } else {
      if (state["lives"] == 0) {
        return (
          <div className="App">
            <h1>Game Over!</h1>
            <button onClick={reset}>Reset</button>
          </div>
        );
      } else {
        return (
          <div className="App">
            <h2>Lives: {state["lives"]} </h2>
            <Guesses guesses={state["guesses"]} scores={state["scores"]}></Guesses><br></br>
            <input type="text" value={text} onChange={updateText} onKeyPress={keyPressed} />
            <br></br><br></br>
            <button onClick={guess}>Guess</button>
            <button onClick={reset}>Reset</button>
          </div>
        );
      }
    }

  }
}

export default Bulls;
