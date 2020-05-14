//
//  HCPatientListCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCPatientListCell_identifier = "HCPatientListCell_identifier"

class HCPatientListCell: UITableViewCell {

    @IBOutlet weak var avatarOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
