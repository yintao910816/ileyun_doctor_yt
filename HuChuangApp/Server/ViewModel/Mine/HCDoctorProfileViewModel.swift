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
    
    override init() {
        super.init()
        
        cellDidSelected
            .subscribe(onNext: { [unowned self] model in
                if model.title == "擅长疾病" || model.title == "个人简介" {
                    var datas = self.listData.value.first!.items
                    if let idx = datas.firstIndex(where: { $0.title == model.title }) {
                        let newTextViewItem = HCListCellItem(cellHeight: datas[idx+1].cellHeight == 0 ? 160 : 0,
                                                     cellIdentifier: datas[idx+1].cellIdentifier,
                                                     showBottomLine: false)
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
        })
            .disposed(by: disposeBag)
    }
    
    private func prepareData() {
        var avatarDetail: String = "请上传"
        var avatarDetailIcon: String = ""
        if let user = HCHelper.share.userInfoModel, user.headPath.count > 0 {
            avatarDetail = ""
            avatarDetailIcon = user.headPath
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
                                        detailTitle: "请输入",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        segue: "editNickNameSegue"),
                         HCListCellItem(title: "职称",
                                        detailTitle: "请选择",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier),
                         HCListCellItem(title: "医院",
                                        detailTitle: "请选择",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier),
                         HCListCellItem(title: "科室",
                                        detailTitle: "请选择",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier),
                         HCListCellItem(title: "擅长疾病",
                                        detailTitle: "请输入",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        showBottomLine: true),
                         HCListCellItem(cellHeight: 0,
                                        cellIdentifier: HCListTextViewCell_identifier,
                                        showBottomLine: true),
                         HCListCellItem(title: "个人简介",
                                        detailTitle: "请输入",
                                        titleColor: .black,
                                        cellIdentifier: HCListDetailCell_identifier,
                                        showBottomLine: true),
                         HCListCellItem(cellHeight: 0,
                                        cellIdentifier: HCListTextViewCell_identifier,
                                        showBottomLine: true)
        ]
        
        listData.value = [SectionModel.init(model: 0, items: totleData)]
    }
    
    public func cellModel(for indexPath: IndexPath) ->HCListCellItem {
        return listData.value[0].items[indexPath.row]
    }
}
