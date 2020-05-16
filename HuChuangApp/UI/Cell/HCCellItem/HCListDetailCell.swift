//
//  HCListDetailCell.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListDetailCell_identifier = "HCListDetailCell"

class HCListDetailCell: HCBaseListCell {

    public var detailTitleLabel: UILabel!
    private var detailIcon: UIImageView!

    override func loadView() {
        detailTitleLabel = UILabel()
        detailTitleLabel.textAlignment = .right
        detailTitleLabel.font = .font(fontSize: 14)

        detailIcon = UIImageView()
        detailIcon.contentMode = .scaleAspectFill
        detailIcon.clipsToBounds = true
        
        contentView.addSubview(detailTitleLabel)
        contentView.addSubview(detailIcon)
    }
    
    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            detailTitleLabel.text = model.detailTitle
            detailTitleLabel.textColor = model.detailTitleColor
            
            if detailIcon.layer.cornerRadius != model.detailIconCorner {
                detailIcon.layer.cornerRadius = model.detailIconCorner                
            }
            
            if model.iconType == .local {
                detailIcon.image = UIImage(named: model.detailIcon)
            }else {
                detailIcon.setImage(model.detailIcon, .userIcon)
            }
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let detailSize = detailTitleLabel.sizeThatFits(CGSize.init(width: Double(Float(MAXFLOAT)), height: 20.0))
        var detailTitleX: CGFloat = 0
        var detailIconX: CGFloat = 0

        if model.detailIcon.count == 0 {
            detailIcon.frame = .zero
            detailTitleX = model.showArrow ? (width - 15 - 8 - detailSize.width - 5) : (width - 15 - detailSize.width);
            detailTitleLabel.frame = .init(x: detailTitleX,
                                           y: (height - detailSize.height) / 2.0,
                                           width: detailSize.width,
                                           height: detailSize.height)
        }else {
            detailIconX = model.showArrow ? (width - 15 - 8 - 5 - model.detailIconSize.width) : (width - 15 - model.detailIconSize.width);
            detailIcon.frame = .init(x: detailIconX,
                                     y: (height - model.detailIconSize.height) / 2.0,
                                     width: model.detailIconSize.width,
                                     height: model.detailIconSize.height)
            if model.detailTitle.count > 0 {
                detailTitleLabel.frame = .init(x: detailIcon.frame.minX - detailSize.width - 10,
                                               y: (height - detailSize.height) / 2.0,
                                               width: detailSize.width,
                                               height: detailSize.height)
            }else {
                detailTitleLabel.frame = .zero
            }
        }
    }
}
