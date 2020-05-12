//
//  HomeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel: BaseViewModel {

    public var bannerModelObser = Variable([HCBannerModel]())

    override init() {
        super.init()
        
    }
    
    private func requestBanner() {
        
    }
}
