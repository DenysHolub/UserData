//
//  UserTableViewCell.swift
//  UserData
//
//  Created by Denys on 9/20/16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var linkLabel: UILabel!
  
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
