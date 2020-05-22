//
//  HCPatientSearchController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientSearchController: BaseViewController {

    @IBOutlet weak var searchBar: TYSearchBar!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var tbHeaderView: UILabel!

    private var viewModel: HCPatientSearchViewModel!
    
    override func setupUI() {
        searchBar.coverButtonEnable = false
        searchBar.rightItemTitle = "取消"
        searchBar.searchPlaceholder = "搜索患者"
        searchBar.inputBackGroundColor = RGB(246, 246, 246)
        searchBar.returnKeyType = .search
        
        searchBar.beginSearch = { [unowned self] in
            self.viewModel.excuteSearchAction.onNext($0)
        }
        
        tabelView.rowHeight = 63
        tabelView.register(UINib.init(nibName: "HCPatientListCell", bundle: nil),
                           forCellReuseIdentifier: HCPatientListCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCPatientSearchViewModel()
        
        viewModel.datasource.asDriver()
            .do(onNext: { [weak self] in self?.tbHeaderView.isHidden = $0.count == 0 })
            .drive(tabelView.rx.items(cellIdentifier: HCPatientListCell_identifier, cellType: HCPatientListCell.self)) { _, model, cell in
                cell.model = model
                cell.isHiddenSubTitle = false
        }
        .disposed(by: disposeBag)
        
        tabelView.rx.modelSelected(HCPatientListItemModel.self)
            .bind(to: viewModel.modelSelectedAction)
            .disposed(by: disposeBag)
    }
}
