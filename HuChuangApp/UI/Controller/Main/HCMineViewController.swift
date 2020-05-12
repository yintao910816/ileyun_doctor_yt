//
//  HCMineViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCMineViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var header: MineHeaderView!
    
    private var viewModel: HCMineViewModel!
        
    override func setupUI() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.backgroundColor = RGB(249, 249, 249)
        
        header =  MineHeaderView.init(frame: .init(x: 0, y: 0, width: tableView.width, height: 100))
        tableView.tableHeaderView = header
                
        tableView.rowHeight = 50
        tableView.register(HCBaseListCell.self, forCellReuseIdentifier: HCBaseListCell_identifier)
        tableView.register(HCListButtonCell.self, forCellReuseIdentifier: HCListButtonCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCMineViewModel()
                
        viewModel.userInfo
            .bind(to: header.userModel)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HCListCellItem.self)
            .bind(to: viewModel.cellDidSelectedSubject)
            .disposed(by: disposeBag)
        
        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<Int, HCListCellItem>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            if indexPath.section == 3 {
                let cell = (tb.dequeueReusableCell(withIdentifier: HCListButtonCell_identifier) as! HCListButtonCell)
                cell.model = model
                return cell
            }
            
            let cell = (tb.dequeueReusableCell(withIdentifier: HCBaseListCell_identifier) as! HCBaseListCell)
            cell.model = model
            return cell
        })
        
        viewModel.datasource
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
                
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCMineViewController: UITableViewDelegate {
            
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sepView = UIView()
        sepView.backgroundColor = RGB(249, 249, 249)
        return sepView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
