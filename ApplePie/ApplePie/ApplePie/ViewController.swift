//
//  ViewController.swift
//  ApplePie
//
//  Created by 김기현 on 2021/03/12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButton: [UIButton]!
    
    // Game Setting
    private var listOfItem: [String] = ["buccaneer", "swift", "glorious", "incandescent", "bug", "program"]
    private let incorrectMovesAllowed: Int = 7
    
    private var totalWins = 0 {
        didSet {
            alertView(title: "정답!", message: "정답입니다!")
            newRound()
        }
    }
    private var totalLosses = 0 {
        didSet {
            alertView(title: "실패!", message: "틀렸습니다!")
            newRound()
        }
    }
    
    // Game Model
    var currentGame: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newRound()
    }
    
    func newRound() {
        if !listOfItem.isEmpty {
            let newWord = listOfItem.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, gussedLetters: [])
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false)
        }
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButton {
            button.isEnabled = enable
        }
    }
    
    func updateUI() {
        var letters = [String]()
        guard let currentGame = currentGame else { return }
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "tree")
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame?.playerGussed(letter: letter)
        updateGameState()
    }
    
    func updateGameState() {
        if currentGame?.incorrectMovesRemaining == 0 {
            totalLosses += 1
        } else if currentGame?.word == currentGame?.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func alertView(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

