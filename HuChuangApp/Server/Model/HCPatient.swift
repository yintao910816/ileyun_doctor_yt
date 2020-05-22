//
//  HCPatient.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

/// 患者管理-分组数据
class HCPatientListModel: HJModel {
    var id: String = ""
    var type: Int = 0
    var createDate: String = ""
    var tagName: String = ""
    var memberList: [HCPatientListItemModel] = []
    var memberCount: Int = 0
}

class HCPatientListItemModel: HJModel {
    var tagId: String = ""
    var tagName: String = ""
    var memberId: String = ""
    var memberName: String = ""
    var headPath: String = ""
    var userId: String = ""
}

/// 患者搜索
class HCPatientSearchDataModel: HJModel {
    var memberLsit: [HCPatientListItemModel] = []
}

/// 患者管理-周期档案
class HCPatientCircleModel: HJModel {
 

}

