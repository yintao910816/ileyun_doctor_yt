//
//  MineViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/13.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCMineViewModel: BaseViewModel, VMNavigation {
    
    let userInfo = PublishSubject<HCUserModel>()
    let datasource = PublishSubject<[SectionModel<Int, HCListCellItem>]>()
        
    override init() {
        super.init()
             
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [unowned self] user in
                self.userInfo.onNext(user)
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [unowned self] in self.requestUserInfo() })
            .disposed(by: disposeBag)
    }
    
    private func requestUserInfo() {
        let dataList = [SectionModel.init(model: 0, items: [HCListCellItem(title: "个人账单",
                                                                           titleIcon: "my_icon_bill",
                                                                           segue: "monthBillSegue")]),
                        SectionModel.init(model: 1, items: [HCListCellItem(title: "患者管理",
                                                                           titleIcon: "my_icon_patient",
                                                                           segue: "ConsultMemberListSegue"),
                                                            HCListCellItem(title: "医生资料",
                                                                           titleIcon: "my_icon_data",
                                                                           segue: "doctorProfileSegue"),
                                                            HCListCellItem(title: "咨询设置",
                                                                           titleIcon: "my_icon_consult",
                                                                           segue: "consultSettingSegue")]),
                        SectionModel.init(model: 2, items: [HCListCellItem(title: "分享名片",
                                                                           titleIcon: "my_icon_share",
                                                                           segue: "shareCardSegue")]),
                        SectionModel.init(model: 2, items: [HCListCellItem(title: "退出登录",
                                                                           showArrow: false)])]
        
        datasource.onNext(dataList)
        
        HCProvider.request(.selectInfo)
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { [unowned self] user in
                HCHelper.saveLogin(user: user)
                self.userInfo.onNext(user)
            }) { error in
                PrintLog(error)
            }
            .disposed(by: disposeBag)
    }
}
