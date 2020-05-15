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
            
            detailIcon.image = UIImage(named: model.detailIcon)
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let detailSize = detailTitleLabel.sizeThatFits(CGSize.init(width: Double(Float(MAXFLOAT)), height: 20.0))
        var detailX: CGFloat = 0
        
        if detailIcon.image == nil {
            detailIcon.frame = .zero
            detailX = model.showArrow ? (width - 15 - 8 - detailSize.width - 5) : (width - 15 - detailSize.width);
            detailTitleLabel.frame = .init(x: detailX,
                                           y: (height - detailSize.height) / 2.0,
                                           width: detailSize.width,
                                           height: detailSize.height)
        }else {
            detailIcon.frame = .init(x: width - 15 - detailIcon.image!.size.width,
                                     y: (height - detailIcon.image!.size.height) / 2.0,
                                     width: detailIcon.image!.size.width,
                                     height: detailIcon.image!.size.height)
            detailTitleLabel.frame = .init(x: detailIcon.frame.minX - detailSize.width - 10,
                                           y: (height - detailSize.height) / 2.0,
                                           width: detailSize.width,
                                           height: detailSize.height)
        }
    }
}
