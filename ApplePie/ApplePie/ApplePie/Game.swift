//
//  Game.swift
//  ApplePie
//
//  Created by 김기현 on 2021/03/12.
//

import Foundation

struct Game {
    var word: String
    var incorrectMovesRemaining: Int
    var gussedLetters: [Character]
    
    mutating func playerGussed(letter: Character) {
        gussedLetters.append(letter)
        if !word.contains(letter) {
            incorrectMovesRemaining -= 1
        }
    }
    
    var formattedWord: String {
        var gussedWord = ""
        for letter in word {
            if gussedLetters.contains(letter) {
                gussedWord += "\(letter)"
            } else {
                gussedWord += "_"
            }
        }
        
        return gussedWord
    }
}
