//
//  HCDoctorProfileController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCDoctorProfileController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCDoctorProfileViewModel!
    
    override func setupUI() {
        tableView.rowHeight = 55
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCDoctorProfileViewModel()
        
        viewModel.listData.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCListDetailCell_identifier, cellType: HCListDetailCell.self)) { _, model, cell in
                cell.model = model
        }
        .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}
