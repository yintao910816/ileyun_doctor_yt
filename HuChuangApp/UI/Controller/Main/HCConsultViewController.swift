//
//  HCConsultViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCConsultViewController: BaseViewController, VMNavigation {

    @IBOutlet weak var searchBarOutlet: TYSearchBar!
    @IBOutlet weak var orderOutlet: TYClickedButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCConsultViewModel!
    
    override func setupUI() {
        searchBarOutlet.inputBackGroundColor = RGB(246, 246, 246)
        searchBarOutlet.searchPlaceholder = "搜索患者"
        searchBarOutlet.tapInputCallBack = {
            HCConsultViewController.sbPush("HCMain", "patientSearchController")
        }
        
        tableView.rowHeight = 80
        tableView.register(UINib.init(nibName: "HCConsultListCell", bundle: nil), forCellReuseIdentifier: HCConsultListCell_identifier)
    }
    
    override func rxBind() {
        let orderSignal = orderOutlet.rx.tap.do(onNext: { [weak self] in
            self?.orderOutlet.isSelected = !(self?.orderOutlet.isSelected ?? true)
        })
            .map{ [weak self] in self?.orderOutlet.isSelected ?? false }
            .asDriver(onErrorJustReturn: false)
        
        viewModel = HCConsultViewModel.init(orderDriver: orderSignal)

        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCConsultListCell_identifier, cellType: HCConsultListCell.self)) { _, model, cell in
                cell.consultModel = model
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HCConsultModel.self).asDriver()
            .drive(viewModel.modelSelected)
            .disposed(by: disposeBag)
        
        tableView.prepare(viewModel)
        tableView.headerRefreshing()
    }    
}
