//
//  HCHomeBannerCell.swift
//  HuChuangApp
//
//  Created by yintao on 2020/5/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

public let HCHomeBannerCell_identifier = "HCHomeBannerCell_identifier"

class HCHomeBannerCell: UICollectionViewCell {
    
    private var carouselView: CarouselView!
    
    public var tapCarouselCallBack: ((HCBannerModel) ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        carouselView = CarouselView()
        carouselView.tapCallBack = { [weak self] in self?.tapCarouselCallBack?($0 as! HCBannerModel) }
        contentView.addSubview(carouselView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var carouselData: [HCBannerModel]! {
        didSet {
            carouselView.setData(source: carouselData)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        carouselView.frame = self.bounds
    }
}
