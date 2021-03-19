//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by 김기현 on 2021/03/17.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    private let estimatedSize: CGFloat = 80
    var emojiTitle: [String] = ["Emoji", "Emoji2"]
    
    var emojis: [Emoji] = [
        Emoji(symbol: "😀",
              name: "Grinning Face",
              description: "A typical smiley face.",
              usage: "happiness"),
        Emoji(symbol: "😕",
              name: "Confused Face",
              description: "A confused, puzzled face.",
              usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍",
              name: "Heart Eyes",
              description: "A smiley face with hearts for eyes.",
              usage: "love of something; attractive"),
        Emoji(symbol: "👮",
              name: "Police Officer",
              description: "A police officer wearing a blue cap with a gold badge.",
              usage: "person of authority"),
        Emoji(symbol: "🐢",
              name: "Turtle",
              description: "A cute turtle.",
              usage: "Something slow"),
        Emoji(symbol: "🐘",
              name: "Elephant",
              description: "A gray elephant.",
              usage: "good memory")
        ]
    
    var emojis2: [Emoji] = [
        Emoji(symbol: "🍝",
              name: "Spaghetti",
              description: "A plate of spaghetti.",
              usage: "spaghetti"),
        Emoji(symbol: "🎲",
              name: "Die",
              description: "A single die.",
              usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️",
              name: "Tent",
              description: "A small tent.",
              usage: "camping"),
        Emoji(symbol: "📚",
              name: "Stack of Books",
              description: "Three colored books stacked on each other.",
              usage: "homework, studying"),
        Emoji(symbol: "💔",
              name: "Broken Heart",
              description: "A red, broken heart.",
              usage: "extreme sadness"),
        Emoji(symbol: "💤",
              name: "Snore",
              description: "Three blue \'z\'s.",
              usage: "tired, sleepiness"),
        Emoji(symbol: "🏁",
              name: "Checkered Flag",
              description: "A black-and-white checkered flag.",
              usage: "completion")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return emojiTitle.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return emojiTitle[0]
        } else {
            return emojiTitle[1]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return emojis.count
        } else {
            return emojis2.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as? EmojiTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            let emoji = emojis[indexPath.row]
            cell.update(with: emoji)
        } else {
            let emoji2 = emojis2[indexPath.row]
            cell.update(with: emoji2)
        }
        
        cell.showsReorderControl = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji: Emoji
        if sourceIndexPath.section == 0 {
            movedEmoji = emojis.remove(at: sourceIndexPath.row)
            emojis.insert(movedEmoji, at: destinationIndexPath.row)
        } else {
            movedEmoji = emojis2.remove(at: sourceIndexPath.row)
            emojis2.insert(movedEmoji, at: destinationIndexPath.row)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && editingStyle == .delete {
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .delete {
            emojis2.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedSize
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var emoji: Emoji
        
        if indexPath.section == 0 {
            emoji = emojis[indexPath.row]
        } else {
            emoji = emojis2[indexPath.row]
        }
        
        print("\(emoji.symbol) \(indexPath)")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedSize
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 246 / 255, alpha: 1)
    }
}
