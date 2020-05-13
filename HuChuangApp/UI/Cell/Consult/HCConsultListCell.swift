//
//  HCConsultListCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultListCell_identifier = "HCConsultListCell_identifier"

class HCConsultListCell: UITableViewCell {

    @IBOutlet weak var coverOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var detailOutlet: UILabel!
    @IBOutlet weak var subTitleOutlet: UILabel!
    @IBOutlet weak var markOutlet: UILabel!
    @IBOutlet weak var markWidthCns: NSLayoutConstraint!
    @IBOutlet weak var markRightCns: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    public var consultModel: HCConsultModel! {
        didSet {
            coverOutlet.setImage(consultModel.headImg)
            titleOutlet.text = consultModel.patientName
            detailOutlet.text = consultModel.create_time.timeSeprate2()
            subTitleOutlet.text = consultModel.content
            
            markOutlet.isHidden = consultModel.unReplyCount == 0
            markOutlet.text = "\(consultModel.unReplyCount)"
            let size = markOutlet.sizeThatFits(CGSize.init(width: Double(MAXFLOAT), height: 18.0))
            markWidthCns.constant = size.width + 10
            markRightCns.constant = markWidthCns.constant / 2.0
        }
    }
}
