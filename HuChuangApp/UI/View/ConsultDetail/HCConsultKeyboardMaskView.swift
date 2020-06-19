//
//  HCConsultKeyboardMaskView.swift
//  HuChuangApp
//
//  Created by yintao on 2020/6/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCConsultKeyboardMaskView: UIView {

    private var textInputView: TYChatKeyBoardView!
    private var tapGesture: UITapGestureRecognizer!
    
    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGB(10, 10, 10, 0.2)
        isHidden = true
        
        textInputView = TYChatKeyBoardView()
        addSubview(textInputView)
        
        tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.endEdit()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func tapAction() {
        endEdit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textInputView.frame = .init(x: 0, y: height + 49, width: width, height: 49)
    }
}

extension HCConsultKeyboardMaskView {
    
    public func beginEdit() {
        isHidden = false
        textInputView.tf_becomeFirstResponder()
    }
    
    public func endEdit() {
        isHidden = true
        textInputView.resignFirstResponder()
    }
    
    public var coverView: UIView! {
        get {
            return textInputView
        }
    }
}
