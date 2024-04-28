//
//  PostTableViewCell.swift
//  JsonAssignment
//
//  Created by Avinash Thakur on 26/04/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCellContent(post: Post) {
        self.idLabel.text = "Post id: \(post.id)"
        self.userIdLabel.text = "User id: \(post.userId)"
        self.titleLabel.text = "Title: \(post.title)"
        self.descLabel.text = "Description:\(post.body)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
