//
//  HCHome.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import HandyJSON

class HCBannerModel: HJModel {
    public var clickCount: Int = 0
    public var createTime: Int = 0
    public var discibe: String = ""
    public var hospitalId: String = ""
    public var id: String = ""
    public var order: Int = 0
    public var path: String = ""
    public var title: String = ""
    public var type: Int = 0
    public var updateTime: Int = 0
    public var link: String = ""
    
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &link, name: "url")
    }
}

extension HCBannerModel: CarouselSource {

    var url: String? {
        if path.contains("http"){
            return path
        }else{
            return "\(APIAssistance.baseImage)\(path)"
        }
    }
}
