//
//  HomeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCHomeViewModel: BaseViewModel {

    let datasource = PublishSubject<[SectionModel<Int, HCHomeCellItemModel>]>()

    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.setupData(bannerData: [])
            self?.requestBanner()
        })
        .disposed(by: disposeBag)
    }
    
    private func requestBanner() {
        HCProvider.request(.selectBanner)
            .map(models: HCBannerModel.self)
            .subscribe(onSuccess: { [weak self] in self?.setupData(bannerData: $0) })
            { _ in }
            .disposed(by: disposeBag)
    }
    
    private func setupData(bannerData: [HCBannerModel]) {
        let dataList = [SectionModel.init(model: 0,
                                          items: [HCHomeCellItemModel(identifier: HCHomeBannerCell_identifier,
                                                                      bannerData: bannerData,
                                                                      type: .banner)])]
        datasource.onNext(dataList)
    }
}

public enum HCHomeCellType {
    case banner
    case notification
    case function
}
struct HCHomeCellItemModel {
    var identifier: String = ""
    
    var bannerData: [HCBannerModel] = []
    var type: HCHomeCellType = .banner
}
