//
//  HCBaseConsultCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/28.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCBaseConsultCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var model: HCConsultDetailConsultListModel! {
        didSet {

        }
    }
}
