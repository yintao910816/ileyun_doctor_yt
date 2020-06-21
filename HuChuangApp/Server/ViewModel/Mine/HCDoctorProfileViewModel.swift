//
//  HCDoctorProfileViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCDoctorProfileViewModel: BaseViewModel {
    
    public let listData = Variable([SectionModel<Int, HCListCellItem>]())
    public let cellDidSelected = PublishSubject<HCListCellItem>()
    public var zpListSource: [HCZPListModel] = []
    public var departmentSource: [HCDepartmentModel] = []

    public let postEditSubject = PublishSubject<HCListCellItem>()
    
    override init() {
        super.init()
        
        cellDidSelected
            .subscribe(onNext: { [unowned self] model in
                if model.title == "擅长疾病" || model.title == "个人简介" {
                    var datas = self.listData.value.first!.items
                    if let idx = datas.firstIndex(where: { $0.title == model.title }) {
                        let newTextViewItem = HCListCellItem(detailTitle: datas[idx+1].detailTitle,
                                                             cellHeight: datas[idx+1].cellHeight == 0 ? 160 : 0,
                                                             cellIdentifier: datas[idx+1].cellIdentifier,
                                                             showBottomLine: false,
                                                             key: datas[idx+1].key)
                        datas.replaceSubrange(idx+1..<idx+2, with: [newTextViewItem])
                        
                        let newItem = HCListCellItem(title: model.title,
                                                     detailTitle: model.detailTitle,
                                                     titleColor: model.titleColor,
                                                     cellIdentifier: model.cellIdentifier,
                                                     showBottomLine: newTextViewItem.cellHeight == 0)
                        datas.replaceSubrange(idx..<idx+1, with: [newItem])

                        self.listData.value = [SectionModel.init(model: 0, items: datas)]
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.prepareData()
            self?.requestAll()
        })
            .disposed(by: disposeBag)
        
        postEditSubject
            .subscribe(onNext: { [unowned self] in self.requestUpdateInfo(model: $0) })
            .disposed(by: disposeBag)
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] _ in
                self?.prepareData()
            })
            .disposed(by: disposeBag)
    }
        
    private func prepareData() {
        var avatarDetail: String = "请上传"
        var avatarDetailIcon: String = ""
        
        let user = HCHelper.share.userInfoModel
        if user?.headPath.count ?? 0 > 0 {
            avatarDetail = ""
            avatarDetailIcon = user!.headPath
        }
        
        let totleData = [HCListCellItem(title: "照片",
                                        detailTitle: avatarDetail,
                                        detailIcon: avatarDetailIcon,
                                        detailIconSize: .init(width: 40, height: 40),
                                        iconType: .network,
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        segue: "editIconSegue"),
                         HCListCellItem(title: "姓名",
                                        detailTitle: fixText(orNilString: user?.name, str: "请输入"),
                                        titleColor: .black,
                                        showArrow: false,
                                        cellIdentifier: HCListDetailInputCell_identifier,
                                        key: "name"),
                         HCListCellItem(title: "职称",
                                        detailTitle: fixText(orNilString: user?.technicalPost, str: "请输入"),
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        key: "technicalPost",
                                        idKey: "technicalPostId",
                                        id: user?.technicalPostId ?? ""),
                         HCListCellItem(title: "医院",
                                        detailTitle: fixText(orNilString: user?.unitName, str: ""),
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        showBottomLine: true),
                         HCListCellItem(title: "科室",
                                        detailTitle: fixText(orNilString: user?.departmentName, str: "请输入"),
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        key: "departmentName",
                                        idKey: "departmentId",
                                        id: user?.departmentId ?? ""),
                         HCListCellItem(title: "擅长疾病",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        showBottomLine: true),
                         HCListCellItem(detailTitle: fixText(orNilString: user?.skilledIn, str: "请输入"),
                                        cellHeight: 0,
                                        cellIdentifier: HCListTextViewCell_identifier,
                                        showBottomLine: true,
                                        key: "skilledIn"),
                         HCListCellItem(title: "个人简介",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        showBottomLine: true),
                         HCListCellItem(detailTitle: fixText(orNilString: user?.brief, str: "请输入"),
                                        cellHeight: 0,
                                        cellIdentifier: HCListTextViewCell_identifier,
                                        showBottomLine: true,
                                        key: "brief")
        ]
        
        listData.value = [SectionModel.init(model: 0, items: totleData)]
    }
    
    public func cellModel(for indexPath: IndexPath) ->HCListCellItem {
        return listData.value[0].items[indexPath.row]
    }
    
    private func fixText(orNilString: String?, str: String) ->String {
        if let s = orNilString, s.count > 0 {
            return s
        }
        
        return str
    }
}

extension HCDoctorProfileViewModel {
    
    private func requestAll() {
        hud.noticeLoading()
        Observable.combineLatest(requestUserInfo(), requestZPList(), requestAllDepartment()) { ($0,$1,$2) }
            .subscribe(onNext: { [weak self] data in
                HCHelper.saveLogin(user: data.0)
                self?.prepareData()
                
                self?.zpListSource.removeAll()
                self?.departmentSource.removeAll()
                self?.zpListSource.append(contentsOf: data.1)
                self?.departmentSource.append(contentsOf: data.2)
                self?.hud.noticeHidden()
            }, onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            })
            .disposed(by: disposeBag)
    }
    
    /// 用户信息
    private func requestUserInfo()->Observable<HCUserModel> {
        return HCProvider.request(.selectInfo)
            .map(model: HCUserModel.self)
            .asObservable()
            .catchErrorJustReturn(HCUserModel())
    }

    /// 职称
    private func requestZPList() ->Observable<[HCZPListModel]> {
        return HCProvider.request(.selectZPList(parentCode: .doctorRole))
            .map(models: HCZPListModel.self)
            .asObservable()
            .catchErrorJustReturn([HCZPListModel]())
    }
    
    /// 科室
    private func requestAllDepartment() ->Observable<[HCDepartmentModel]> {
        HCProvider.request(.allDepartment)
            .map(models: HCDepartmentModel.self)
            .asObservable()
            .catchErrorJustReturn([HCDepartmentModel]())
    }
    
    /// 修改
    private func requestUpdateInfo(model: HCListCellItem) {
        if let user = HCHelper.share.userInfoModel, var params = user.toJSON() {
            hud.noticeLoading()
            
            if model.idKey.count > 0 {
                params[model.idKey] = model.id
            }
            params[model.key] = model.detailTitle
            HCProvider.request(.updateExtInfo(params: params))
                .map(model: HCUserModel.self)
                .subscribe(onSuccess: { [weak self] user in
                    HCHelper.saveLogin(user: user)
                    self?.hud.noticeHidden()
                }) { [weak self] in
                    self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
        }
    }
}
