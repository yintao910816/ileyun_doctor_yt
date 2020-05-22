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
    @IBOutlet weak var subTitleOutlet: UILabel!
    
    @IBOutlet weak var titleCenterCns: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public var model: HCPatientListItemModel! {
        didSet {
            avatarOutlet.setImage(model.headPath)
            titleOutlet.text = model.memberName
            subTitleOutlet.text = "来自分组：\(model.tagName)"
        }
    }
    
    public var isHiddenSubTitle: Bool = true {
        didSet {
            subTitleOutlet.isHidden = isHiddenSubTitle
            titleCenterCns.constant = isHiddenSubTitle ? 0 : -10
        }
    }
}
