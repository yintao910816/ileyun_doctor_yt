//
//  HCHomeFuncCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCHomeFuncCell_identifier = "HCHomeFuncCell_identifier"

class HCHomeFuncCell: UICollectionViewCell {
    
    private var bgImgV: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgImgV = UIImageView.init()
        bgImgV.backgroundColor = .clear
        contentView.addSubview(bgImgV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: HCHomeCellItemModel! {
        didSet {
            bgImgV.image = model.funcImage
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImgV.frame = self.bounds
    }
}
