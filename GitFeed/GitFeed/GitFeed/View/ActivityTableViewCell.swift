//
//  ActivityTableViewCell.swift
//  GitFeed
//
//  Created by 김기현 on 2021/04/06.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
