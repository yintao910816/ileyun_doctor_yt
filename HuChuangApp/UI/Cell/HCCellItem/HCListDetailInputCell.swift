//
//  HCListDetailInputCell.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/19.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public let HCListDetailInputCell_identifier = "HCListDetailInputCell"
public let HCListDetailInputCell_height: CGFloat = 50

class HCListDetailInputCell: HCBaseListCell {

    private var inputTf: UITextField!
    
    override func loadView() {
        arrowImgV.isHidden = true
        
        inputTf = UITextField()
        inputTf.returnKeyType = .done
        inputTf.textAlignment = .right
        inputTf.placeholder = "请输入"
        inputTf.font = .font(fontSize: 14)
        inputTf.textColor = .black
        inputTf.delegate = self
        
        contentView.addSubview(inputTf)
        
        inputTf.snp.makeConstraints {
            $0.right.equalTo(contentView).offset(-15)
            $0.size.equalTo(CGSize.init(width: 100, height: 25))
            $0.centerY.equalTo(contentView.snp.centerY)
        }
    }

    override var model: HCListCellItem! {
        didSet {
            super.model = model
            
            inputTf.text = model.detailTitle
            inputTf.placeholder = model.placeholder
            inputTf.textColor = model.detailTitleColor
            
            if model.showArrow && arrowImgV.isHidden {
                inputTf.snp.updateConstraints {
                    $0.right.equalTo(contentView).offset(-7 - 8 - 15)
                    $0.size.equalTo(model.inputSize)
                }
            }else {
                inputTf.snp.updateConstraints {
                    $0.size.equalTo(model.inputSize)
                }
            }
        }
    }
}

extension HCListDetailInputCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model.detailTitle = textField.text ?? ""
        didEndEditCallBack?(textField.text ?? "")
        didEndEditWithModel?(model)
        textField.resignFirstResponder()
        return true
    }
}
