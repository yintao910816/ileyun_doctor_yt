//
//  HCConsultDetailTimeCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/24.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCConsultDetailTimeCell_identifier = "HCConsultDetailTimeCell_identifier"

class HCConsultDetailTimeCell: HCBaseConsultCell {

    private var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.textColor = RGB(136, 136, 136)
        titleLabel.backgroundColor = RGB(238, 238, 238)
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 9
        titleLabel.clipsToBounds = true
        titleLabel.font = .font(fontSize: 12, fontName: .PingFMedium)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var model: HCConsultDetailConsultListModel! {
        didSet {
            titleLabel.text = model.timeString
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = model.getTimeFrame
    }
}
