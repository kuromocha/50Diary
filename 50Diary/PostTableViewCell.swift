//
//  PostTableViewCell.swift
//  50Diary
//
//  Created by 嘉山正太郎 on 2020/11/20.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postedLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
