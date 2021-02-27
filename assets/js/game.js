/**
 * Generates a random sequence of 4 unique digits.
 */
export function generate_secret() {
    let secret = ''
    while (secret.length < 4) {
        let temp = Math.floor(Math.random() * 10);
        if (!secret.includes(temp)) {
            secret = secret + temp;
        }
    }

    return secret;
}

/**
 * Calculates how many bulls and cows are in the given guess and appends it to the dictionary containing
 * all guesses and their corressponding bull/cow score.
 * 
 * A dictionary is used to automatically eliminate duplicate guesses. 
 * 
 * @param {*} guesses dictionary of guesses and corresponding bull/cow score
 * @param {*} guess current guess being scored
 * @param {*} secret the secret value being compared against
 */
export function checkguess(guesses, guess, secret) {
    let bulls = 0;
    let bullvalues = [];
    let cows = 0;

    for (let i = 0; i < secret.length; i++) {
        if (secret[i] === guess[i]) {
            bulls += 1;
            bullvalues.push(secret[i]);
        }
    }

    for (let i = 0; i < secret.length; i++) {
        if ((guess.includes(secret[i])) && (!bullvalues.includes(secret[i]))) {
            cows += 1;
        }
    }

    guesses[guess] = bulls + " Bulls " + cows + " Cows ";
    return guesses;
}

/**
 * Checks to make sure the inputted guess by the user is 4 unique digits.
 * 
 * @param {*} text guess inputted by the user
 */
export function checkUnique(text){
    let temp = true;
    let check_list = [];
    
    for(let i = 0; i < 10; i ++) {
        check_list.push(false);
    }

    for(let i = 0; i<text.length; i++) {
        if (check_list[text[i]] === true) {
            temp = false;
        } else {
            check_list[text[i]] = true;
        }
    }

    return temp
}

/**
 * Checks to make sure the guess inputted by the user is 4 characters long, composed of only digits, and all 
 * 4 characters are unique. 
 * 
 * @param {*} text guess inputted by the user
 */
export function validateGuess(text) {
    let valid = true;
    let valid_char = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    if (text.length !== 4) {
        valid = false;
    }

    for (let i = 0; i < text.length; i++) {
        if (!valid_char.includes(text[i])) {
            valid = false;
        }
    }

    if (!checkUnique(text)) {
        valid = false;
    }

    return valid;
}