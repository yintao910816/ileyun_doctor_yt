//
//  HCConsultDetailStatusHeaderView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultDetailStatusHeaderView: UIView {

    @IBOutlet var contentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView = (Bundle.main.loadNibNamed("HCConsultDetailStatusHeaderView", owner: self, options: nil)?.first as! UIView)
        contentView.backgroundColor = .clear
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
    }
}
