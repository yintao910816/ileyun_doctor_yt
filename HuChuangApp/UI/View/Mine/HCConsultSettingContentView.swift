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
    
    @IBOutlet weak var firstSectionHeightCns: NSLayoutConstraint!
    @IBOutlet weak var firstSectionShadowView: UIView!
    
    @IBOutlet weak var secondSectionHeightCns: NSLayoutConstraint!
    @IBOutlet weak var secondSectionShadowView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = (Bundle.main.loadNibNamed("HCConsultSettingContentView", owner: self, options: nil)?.first as! UIView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints{ $0.edges.equalTo(UIEdgeInsets.zero) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
