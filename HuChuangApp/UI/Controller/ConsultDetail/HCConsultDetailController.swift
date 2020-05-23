//
//  HCConsultDetailController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCConsultDetailController: BaseViewController {

    @IBOutlet weak var statusOutlet: HCConsultDetailStatusHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    private var memberId: String = ""
    private var id: String = ""
    private var viewModel: HCConsultDetailViewModel!
    
    override func setupUI() {
        tableView.register(HCConsultDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: HCConsultDetailSectionHeader_identifier)
        tableView.register(HCConsultDetalCell.self, forCellReuseIdentifier: HCConsultDetalCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCConsultDetailViewModel.init(memberId: memberId, id: id)

        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            let cell = (tb.dequeueReusableCell(withIdentifier: HCConsultDetalCell_identifier) as! HCConsultDetalCell)
            cell.model = model
            return cell
        })

        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.prepare(viewModel, showFooter: false, showHeader: true)
        tableView.headerRefreshing()
    }
    
    override func prepare(parameters: [String : Any]?) {
        memberId = parameters!["memberId"] as! String
        id = parameters!["id"] as! String
    }
}

extension HCConsultDetailController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HCConsultDetailSectionHeader_identifier) as! HCConsultDetailSectionHeader
        header.sectionModel = viewModel.datasource.value[section].model
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.datasource.value[section].model.getSectionHeaderSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.datasource.value[indexPath.section].items[indexPath.row].getCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
