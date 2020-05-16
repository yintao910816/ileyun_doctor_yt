//
//  HCShareCardController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCShareCardController: BaseViewController {

    @IBOutlet weak var avatarOutlet: UIImageView!
    @IBOutlet weak var workRoomOutlet: UILabel!
    @IBOutlet weak var workerOutlet: UILabel!
    @IBOutlet weak var workTypeOutlet: UILabel!
    @IBOutlet weak var hospitalOutlet: UILabel!
    @IBOutlet weak var qrCodeOutlet: UIImageView!
    
    override func setupUI() {

        if let user = HCHelper.share.userInfoModel {
            avatarOutlet.setImage(user.headPath, .userIcon)
            workRoomOutlet.text = "工作室"
            workerOutlet.text = user.technicalPost
            workTypeOutlet.text = user.departmentName
            hospitalOutlet.text = user.unitName
        }
        
    }
}
