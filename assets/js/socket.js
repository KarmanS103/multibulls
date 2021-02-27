import { Socket } from "phoenix";

let socket = new Socket(
  "/socket",
  { params: { token: "" } }
);
socket.connect();

let channel = socket.channel("game:1", {});

let state = {
  guesses: [],
  scores: [],
  won: false,
  lives: 8
};

let callback = null;

// The server sent us a new state.
function state_update(st) {
  console.log("New state", st);
  state = st;
  console.log(state)
  if (callback) {
    callback(st);
  }
}

export function ch_join(cb) {
  callback = cb;
  callback(state);
}

// Attribution: Nat Tuck's Hangman Server side code
export function ch_push(guess) {
  channel.push("guess", guess)
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to push", resp)
    });
}

// Attribution: Nat Tuck's Lecture 9 Code
export function ch_login(name) {
  channel.push("login", {name: name})
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to login", resp)
         });
}

// Attribution: Nat Tuck's Hangman Server side code
export function ch_reset() {
  channel.push("reset", {})
    .receive("ok", state_update)
    .receive("error", resp => {
      console.log("Unable to push", resp)
    });
}

channel.join()
  .receive("ok", state_update)
  .receive("error", resp => {
    console.log("Unable to join", resp)
  });

channel.on("view", state_update);