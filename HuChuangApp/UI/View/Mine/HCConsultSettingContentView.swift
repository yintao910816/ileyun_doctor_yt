//
//  HCConsultSettingContentView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultSettingContentView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var firstSectionShadowView: UIView!
    @IBOutlet weak var secondSectionShadowView: UIView!
    
    public var realHeight: CGFloat = 709

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCConsultSettingContentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
                
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
        
        layoutIfNeeded()
        
        realHeight = secondSectionShadowView.frame.maxY
        
        firstSectionShadowView.setCornerAndShaow()
        secondSectionShadowView.setCornerAndShaow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
