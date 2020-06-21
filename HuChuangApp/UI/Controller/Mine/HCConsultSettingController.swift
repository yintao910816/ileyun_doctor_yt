//
//  HCConsultSettingController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultSettingController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var contentView: HCConsultSettingContentView!
    
    override func setupUI() {
        contentView = HCConsultSettingContentView.init(frame: .init(x: 0, y: 0, width: view.width, height: 719))
        var rect = contentView.frame
        rect.size.height = contentView.realHeight
        contentView.frame = rect
        
        tableView.tableHeaderView = contentView
    }
    
    override func rxBind() {
        
    }
}
