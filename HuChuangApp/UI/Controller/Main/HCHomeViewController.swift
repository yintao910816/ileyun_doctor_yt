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
        collectionView.delegate = self
    }

    override func rxBind() {
        viewModel = HCHomeViewModel()
        
        let signal = RxCollectionViewSectionedReloadDataSource<SectionModel<Int, HCHomeCellItemModel>>.init(configureCell: { _,col,indexPath,model ->UICollectionViewCell in
            let cell = col.dequeueReusableCell(withReuseIdentifier: model.identifier, for: indexPath)
            switch model.type {
            case .banner:
                (cell as! HCHomeBannerCell).carouselData = model.bannerData
            default:
                break
            }
            return cell
        })
        
        viewModel.datasource
            .bind(to: collectionView.rx.items(dataSource: signal))
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
}

extension HCHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var itemSize: CGSize = .zero
        
        if indexPath.section == 0 {
            itemSize = .init(width: collectionView.width, height: 140)
        }else {
            
        }
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : .init(top: 15, left: 15, bottom: 0, right: 15)
    }
}
