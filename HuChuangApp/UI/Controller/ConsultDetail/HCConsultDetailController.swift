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
    @IBOutlet weak var chatKeyboardView: TYChatKeyBoardView!
    
    private var keyboardManager = KeyboardManager()

    private var memberId: String = ""
    private var id: String = ""
    private var viewModel: HCConsultDetailViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardManager.registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardManager.removeNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        keyboardManager.move(coverView: chatKeyboardView, moveView: chatKeyboardView)
    }

    override func setupUI() {
        tableView.register(HCConsultDetailSectionHeader.self, forHeaderFooterViewReuseIdentifier: HCConsultDetailSectionHeader_identifier)
        tableView.register(HCConsultDetalCell.self, forCellReuseIdentifier: HCConsultDetalCell_identifier)
        tableView.register(HCConsultDetailTimeCell.self, forCellReuseIdentifier: HCConsultDetailTimeCell_identifier)
    }
    
    override func rxBind() {
        viewModel = HCConsultDetailViewModel.init(memberId: memberId, id: id)

        let datasource = RxTableViewSectionedReloadDataSource<SectionModel<HCConsultDetailItemModel, HCConsultDetailConsultListModel>>.init(configureCell: { _,tb,indexPath,model ->UITableViewCell in
            let cell = tb.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseConsultCell
            cell.model = model
            return cell
        })

        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

        viewModel.timeObser.asDriver()
            .drive(statusOutlet.timeObser)
            .disposed(by: disposeBag)
        
        viewModel.questionObser.asDriver()
            .drive(statusOutlet.questionObser)
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
