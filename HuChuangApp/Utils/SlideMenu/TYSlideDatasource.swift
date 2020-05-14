//
//  TYSlideDatasource.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/27.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

struct TYSlideItemModel {
    var textColor: UIColor = RGB(53, 53, 53)
    var selectedTextColor: UIColor = HC_MAIN_COLOR
    var lineColor: UIColor = HC_MAIN_COLOR
    var textFont: UIFont = .font(fontSize: 15, fontName: .PingFRegular)
    var selectedTextFont: UIFont = .font(fontSize: 15, fontName: .PingFSemibold)

    var isSelected: Bool = false
    
    var isFullLayout: Bool = true
    
    var title: String = ""
    
    var itemCount: Int = 1
    
    public lazy var contentWidth: CGFloat = {
        if self.isFullLayout {
            return PPScreenW / CGFloat(self.itemCount)
        }
        return self.title.getTexWidth(fontSize: 14, height: 30, fontName: FontName.PingFRegular.rawValue) + 30
    }()
    
    public static func creatSimple(for titles: [String]) ->[TYSlideItemModel] {
        var dataModels: [TYSlideItemModel] = []
        for title in titles {
            var itemModel = TYSlideItemModel()
            itemModel.isSelected = dataModels.count == 0
            itemModel.title = title
            itemModel.itemCount = titles.count
            dataModels.append(itemModel)
        }
        return dataModels
    }
}

class HCSlideItemController: BaseViewController {
    
    public var pageIdx: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavBg = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    public func reloadData(data: Any?) {
        
    }
    
    public func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
        
    }
}
