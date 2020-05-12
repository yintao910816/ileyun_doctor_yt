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
    var canConsult: Bool = false
    var canReserve: Bool = false
    var canSms: Bool = false
    var checkCaseFlag: Bool = false
    var createTime: String = ""
    var department: String = ""
    var deviceType: Bool = true
    var docItem: String = ""
    var docOrder: String = ""
    var docRole: Int = 0
    var duty: String = ""
    var goodProject: String = ""
    var hisNo: String = ""
    var hospitalId: String = ""
    var id: String = ""
    var imgUrl: String = ""
    var isStyle: Bool = false
    var level: Int = 0
    var phone: String = ""
    var pinyin: String = ""
    var price: String = ""
    var realName: String = ""
    var registerId: String = ""
    var sex: Int = 0
    var status: Int = 0
    var token: String = ""
    var updateTime: String = ""
    var version: String = ""
    
    var sexText: String {
        get { return sex == 1 ? "男" : "女" }
    }
    
}
