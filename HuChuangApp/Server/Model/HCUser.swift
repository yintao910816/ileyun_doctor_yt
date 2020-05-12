//
//  HCUser.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import HandyJSON

class HCUserModel: HJModel {
    
    var brief: String = ""
    var docItem: String = ""
    var docRole: String = ""
    var docTitle: String = ""
    var duty: String = ""
    var goodProject: String = ""
    var headImg: String = ""
    var hospitalName: String = ""
    var id: String = ""
    var phone: String = ""
    var realName: String = ""
    var sex: Int = 0
    var teamMember: Int = 0
    var token: String = ""
    var version: String = ""
    
    var sexText: String {
        get { return sex == 1 ? "男" : "女" }
    }
    
}
