//
//  DetailViewController.swift
//  JsonAssignment
//
//  Created by Avinash Thakur on 26/04/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateDetails(post: post)
    }
    
    func updateDetails(post: Post) {
        self.idLabel.text = "Post id: \(post.id)"
        self.userIdLabel.text = "User id: \(post.userId)"
        self.titleLabel.text = "Title: \(post.title)"
        self.descLabel.text = "Description:\(post.body)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
