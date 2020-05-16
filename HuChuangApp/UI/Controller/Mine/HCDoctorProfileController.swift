//
//  HCDoctorProfileController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/16.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class HCDoctorProfileController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HCDoctorProfileViewModel!
    
    override func setupUI() {
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListTextViewCell.self, forCellReuseIdentifier: HCListTextViewCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCDoctorProfileViewModel()
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, HCListCellItem>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell)
            cell.model = model
            return cell
        })
        
        viewModel.listData
            .asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HCListCellItem.self)
            .bind(to: viewModel.cellDidSelected)
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCDoctorProfileController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellModel(for: indexPath).cellHeight
    }
}
