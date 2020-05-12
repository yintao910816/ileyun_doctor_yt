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
    let cellDidSelectedSubject = PublishSubject<HCListCellItem>()

    private var currentType: H5Type?
        
    override init() {
        super.init()
             

        cellDidSelectedSubject
            .subscribe(onNext: { _ in
//                if $0.h5Type == .share {
//                    HCAccountManager.presentShare(thumbURL: UIImage(named: "app_icon")!,
//                                                  title: "爱乐孕",
//                                                  descr: "您的好孕帮手",
//                                                  webpageUrl: HCAccountManager.appstoreURL())
//                }else {
//                    HCHelper.pushLocalH5(type: $0.h5Type)
//                }
            })
            .disposed(by: disposeBag)

        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [unowned self] user in
                self.userInfo.onNext(user)
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [unowned self] in self.requestUserInfo() })
            .disposed(by: disposeBag)
    }
    
    private func requestH5(type: H5Type) ->Observable<H5InfoModel> {
        currentType = type
        
        return HCProvider.request(.unitSetting(type: type))
            .map(model: H5InfoModel.self)
            .asObservable()
    }

    private func requestUserInfo() {
        let dataList = [SectionModel.init(model: 0, items: [HCListCellItem(title: "个人账单", titleIcon: "shouhuodizhi")]),
                        SectionModel.init(model: 1, items: [HCListCellItem(title: "患者管理", titleIcon: "shouhuodizhi"),
                                                            HCListCellItem(title: "医生资料", titleIcon: "shouhuodizhi"),
                                                            HCListCellItem(title: "咨询设置", titleIcon: "shouhuodizhi")]),
                        SectionModel.init(model: 2, items: [HCListCellItem(title: "分享名片", titleIcon: "shouhuodizhi")]),
                        SectionModel.init(model: 2, items: [HCListCellItem(title: "退出登录", showArrow: false)])]
        
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
    
    private func pushH5(model: H5InfoModel) {
        if currentType == .healthRecordsUser {
            pushH5(type: .healthRecordsUser)
            currentType = nil
            return
        }
        
        guard model.setValue.count > 0 else { return }
        
        if model.setValue.count > 0 {
            var url = model.setValue
            PrintLog("h5拼接前地址：\(url)")
            if url.contains("?") == false {
                url += "?token=\(userDefault.token)&unitId=\(userDefault.unitId)"
            }else {
                url += "&token=\(userDefault.token)&unitId=\(userDefault.unitId)"
            }
            PrintLog("h5拼接后地址：\(url)")
            
//            HomeViewModel.push(BaseWebViewController.self, ["url": url])
        }else {
            hud.failureHidden("功能暂不开放")
        }
        
        currentType = nil

//        let url = "\(model.setValue)?token=\(userDefault.token)&unitId=\(AppSetup.instance.unitId)"
//        HomeViewModel.push(BaseWebViewController.self, ["url": url])
    }

    private func pushH5(type: H5Type) {
        var url = ""
        switch type {
        case .healthRecordsUser:
            url = "\(type.getLocalUrl())?token=\(userDefault.token)&unitId=\(userDefault.unitId)&isUserInfoBack=true"
        default:
            break
        }
        if url.count > 0 {
//            HomeViewModel.push(BaseWebViewController.self, ["url": url])
        }
    }
}
