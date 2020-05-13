//
//  HCHomeViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa

class HCHomeViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: HCHomeViewModel!

    override func setupUI() {
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        collectionView.register(HCHomeBannerCell.self, forCellWithReuseIdentifier: HCHomeBannerCell_identifier)
        collectionView.register(UINib.init(nibName: "HCHomeNotificationCell", bundle: nil), forCellWithReuseIdentifier:
            HCHomeNotificationCell_identifier)
        collectionView.register(HCHomeFuncCell.self, forCellWithReuseIdentifier: HCHomeFuncCell_identifier)
        
        collectionView.delegate = self
    }
    
    override func rxBind() {
        viewModel = HCHomeViewModel()
        
        let signal = RxCollectionViewSectionedReloadDataSource<SectionModel<HCHomeCellType, HCHomeCellItemModel>>.init(configureCell: { _,col,indexPath,model ->UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: model.identifier, for: indexPath)
            switch model.type {
            case .banner:
                (cell as! HCHomeBannerCell).carouselData = model.bannerData
            case .notification:
                (cell as! HCHomeNotificationCell).model = model
            case .function:
                (cell as! HCHomeFuncCell).model = model
            }
            return cell
        })
        
        viewModel.datasource
            .asDriver()
            .drive(collectionView.rx.items(dataSource: signal))
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var itemSize: CGSize = .zero
        
        switch viewModel.cellType(for: indexPath.section) {
        case .banner:
            itemSize = .init(width: collectionView.width, height: 140)
        case .notification:
            itemSize = .init(width: collectionView.width - 30, height: 65)
        case .function:
            itemSize = .init(width: (collectionView.width - 45) / 2.0 , height: 80)
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : .init(top: 15, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch viewModel.cellType(for: section) {
        case .function:
            return 15
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch viewModel.cellType(for: section) {
        case .function:
            return 15
        default:
            return 0
        }
    }
}
