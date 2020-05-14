//
//  HCPatientDetailController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientDetailController: BaseViewController {

    private var slideCtrl: TYSlideMenuController!

    override func setupUI() {
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        slideCtrl.pageScroll = { [weak self] page in
            
        }

        slideCtrl.menuItems = TYSlideItemModel.creatSimple(for: ["咨询记录", "健康档案", "患者管理"])
        slideCtrl.menuCtrls = [HCPatientConsultRecordController(),
                               HCPatientHealthArchivesController(),
                               HCPatientManageController()]
    }
    
    override func rxBind() {
        
    }
}
