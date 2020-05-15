//
//  HCPatientCycleCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//  周期档案

import UIKit

public let HCPatientCycleCell_identifier = "HCPatientCycleCell_identifier"

class HCPatientCycleCell: UITableViewCell {

    @IBOutlet weak var circleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        circleOutlet.layer.cornerRadius = 15
        circleOutlet.layer.borderWidth = 1
        circleOutlet.layer.borderColor = HC_MAIN_COLOR.cgColor
    }    
}
