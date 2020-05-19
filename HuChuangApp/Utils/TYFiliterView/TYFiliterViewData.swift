//
//  TYFiliterViewData.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class TYFiliterModel {
    
    public var title: String = ""
    public var normalBGColor: UIColor = .clear
    public var selectedBGColor: UIColor = .clear
    public var normalTextColor: UIColor = RGB(61, 55, 68)
    public var selectedTextColor: UIColor = HC_MAIN_COLOR
    
    public var isSelected: Bool = false

    init() { }
        
    public var contentSize: CGSize {
        get {
            let w = title.getTexWidth(fontSize: 12, height: 48, fontName: FontName.PingFMedium.rawValue) + 50
            return .init(width: w, height: 48)
        }
    }
    
    public var bgColor: UIColor {
        get {
            return isSelected ? selectedBGColor : normalBGColor
        }
    }
    
    public var titleColor: UIColor {
        get {
            return isSelected ? selectedTextColor : normalTextColor
        }
    }
}

class TYFiliterSectionModel {
    
    public var sectionTitle: String = ""

    public var datas: [TYFiliterModel] = []
    
    public class func createData() ->[TYFiliterSectionModel] {
        let titles_1 = ["默认分组", "不孕不育"]

        let section_1 = TYFiliterSectionModel()
        section_1.sectionTitle = ""
        for item in titles_1 {
            let m = TYFiliterModel()
            m.title = item
            section_1.datas.append(m)
        }
                
        return [section_1]
    }
}
