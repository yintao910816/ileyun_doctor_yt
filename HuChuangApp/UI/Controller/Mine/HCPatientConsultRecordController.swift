//
//  HCPatientConsultRecordController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/15.
//  Copyright © 2020 sw. All rights reserved.
//  咨询记录

import UIKit

class HCPatientConsultRecordController: HCSlideItemController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
      override func reloadData(data: Any?) {
//          if let dataModels = data as? [HCArticleItemModel] {
//              datasource = dataModels
//              tableView.reloadData()
//          }
      }

      override func bind<T>(viewModel: RefreshVM<T>, canRefresh: Bool, canLoadMore: Bool, isAddNoMoreContent: Bool) {
    
//          tableView.prepare(viewModel, showFooter: canLoadMore, showHeader: canRefresh, isAddNoMoreContent: isAddNoMoreContent)
      }

}
