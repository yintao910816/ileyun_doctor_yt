//
//  HCHomeNotificationCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCHomeNotificationCell_identifier = "HCHomeNotificationCell_identifier"

class HCHomeNotificationCell: UICollectionViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actions(_ sender: UIButton) {
    
    }
    
    public var model: HCHomeCellItemModel! {
        didSet {
            titleOutlet.attributedText = model.notificationAttributeTitle
        }
    }
}
