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
    
    let datasource = Variable([SectionModel<HCHomeCellType, HCHomeCellItemModel>]())
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.setupData(bannerData: [])
            self?.requestBanner()
        })
            .disposed(by: disposeBag)
    }
    
    public func cellType(for section: Int) ->HCHomeCellType {
        return datasource.value[section].model
    }
    
    private func requestBanner() {
        HCProvider.request(.selectBanner)
            .map(models: HCBannerModel.self)
            .subscribe(onSuccess: { [weak self] in self?.setupData(bannerData: $0) })
            { _ in }
            .disposed(by: disposeBag)
    }
    
    private func setupData(bannerData: [HCBannerModel]) {
        let notiAtt = "您有5条新的咨询消息".attributed(.init(location: 2, length: 1), RGB(255, 153, 255), UIFont.font(fontSize: 15, fontName: .PingFMedium))
        let dataList = [SectionModel.init(model: HCHomeCellType.banner,
                                          items: [HCHomeCellItemModel(identifier: HCHomeBannerCell_identifier,
                                                                      bannerData: bannerData,
                                                                      type: .banner)]),
                        SectionModel.init(model: HCHomeCellType.notification,
                                          items: [HCHomeCellItemModel(identifier: HCHomeNotificationCell_identifier,
                                                                      type: .notification,
                                                                      notificationAttributeTitle: notiAtt)]),
                        SectionModel.init(model: HCHomeCellType.function,
                                          items: [HCHomeCellItemModel(identifier: HCHomeFuncCell_identifier,
                                                                      type: .function,
                                                                      funcType: .operationPlan,
                                                                      funcImage: UIImage(named: "icon_surgery")),
                                                  HCHomeCellItemModel(identifier: HCHomeFuncCell_identifier,
                                                                      type: .function,
                                                                      funcType: .onlineBooking,
                                                                      funcImage: UIImage(named: "icon_appointment")),
                                                  HCHomeCellItemModel(identifier: HCHomeFuncCell_identifier,
                                                                      type: .function,
                                                                      funcType: .onlineConsulte,
                                                                      funcImage: UIImage(named: "icon_consult")),
                                                  HCHomeCellItemModel(identifier: HCHomeFuncCell_identifier,
                                                                      type: .function,
                                                                      funcType: .caseBorrowing,
                                                                      funcImage: UIImage(named: "icon_case")),
                                                  HCHomeCellItemModel(identifier: HCHomeFuncCell_identifier,
                                                                      type: .function,
                                                                      funcType: .numberSource,
                                                                      funcImage: UIImage(named: "icon_source")),
                                                  HCHomeCellItemModel(identifier: HCHomeFuncCell_identifier,
                                                                      type: .function,
                                                                      funcType: .holidayArrangements,
                                                                      funcImage: UIImage(named: "icon_holiday"))])]
        datasource.value = dataList
    }
}

public enum HCHomeCellType {
    case banner
    case notification
    case function
}

public enum HCFunctionType {
    /// 手术计划
    case operationPlan
    /// 在线预约
    case onlineBooking
    /// 在线咨询
    case onlineConsulte
    /// 病例借阅
    case caseBorrowing
    /// 号源设置
    case numberSource
    /// 假日安排
    case holidayArrangements
}

struct HCHomeCellItemModel {
    var identifier: String = ""
    
    var bannerData: [HCBannerModel] = []
    var type: HCHomeCellType = .banner
    
    var notificationAttributeTitle: NSAttributedString = NSAttributedString.init()
    
    var funcType: HCFunctionType = .operationPlan
    var funcImage: UIImage?
}
