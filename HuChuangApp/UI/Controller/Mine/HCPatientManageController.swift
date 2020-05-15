//
//  HCPatientManageController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCPatientManageController: HCSlideItemController {

    private var tableView: UITableView!
    
    private var datasource: [HCListCellItem] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        tableView = UITableView.init(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.rowHeight = 55
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(HCListDetailCell.self, forCellReuseIdentifier: HCListDetailCell_identifier)
        tableView.register(HCListSwitchCell.self, forCellReuseIdentifier: HCListSwitchCell_identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
    }
    
    override func reloadData(data: Any?) {
        tableView.separatorStyle = .none

        if let models = data as? [HCListCellItem] {
            datasource.removeAll()
            datasource.append(contentsOf: models)
            tableView.reloadData()
        }
    }
}

extension HCPatientManageController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as! HCBaseListCell
        cell.model = model
        return cell
    }
}