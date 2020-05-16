//
//  HCDoctorProfileViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCDoctorProfileViewModel: BaseViewModel {
    
    private var totleData: [HCListCellItem] = []
    
    public let listData = Variable([HCListCellItem]())
    
    override init() {
        super.init()
        
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
        
        totleData = [HCListCellItem(title: "照片",
                                    detailTitle: avatarDetail,
                                    detailIcon: avatarDetailIcon,
                                    detailIconSize: .init(width: 40, height: 40),
                                    iconType: .network,
                                    titleColor: .black,
                                    cellIdentifier: HCListDetailCell_identifier),
                     HCListCellItem(title: "姓名",
                                    detailTitle: "请输入",
                                    titleColor: .black,
                                    cellIdentifier: HCListDetailCell_identifier),
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
                                    cellIdentifier: HCListDetailCell_identifier),
                     HCListCellItem(title: "个人简介",
                                    detailTitle: "请输入",
                                    titleColor: .black,
                                    cellIdentifier: HCListDetailCell_identifier)
        ]
        
        listData.value = totleData
    }
}
