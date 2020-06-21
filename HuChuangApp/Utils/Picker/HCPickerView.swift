//
//  HCPickerView.swift
//  HuChuangApp
//
//  Created by sw on 2019/9/25.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

public enum HCPickerAction {
    case cancel
    case ok
}

class HCPicker: UIViewController {
        
    public var toolBar: UIToolbar!
    public var tapGes: UITapGestureRecognizer!
    public var containerView: UIView!
    public var cancelButton: UIButton!
    public var doneButton: UIButton!

    public var titleDes: String = ""
    public var cancelTitle: String = "取消"
    public var okTitle: String = "保存"
    public var okTitleColor: UIColor = HC_MAIN_COLOR
    /// 取消按钮是否有除了隐藏picker的其它功能
    public var isCustomCancel: Bool = false

    public var finishSelected: (((HCPickerAction, String))->())?
    public var finishSelectedModel: (((HCPickerAction, [HCPickerData]))->())?

    public var pickerHeight: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = RGB(10, 10, 10, 0.2)

        ///
        containerView = UIView.init(frame: .init(x: 0, y: view.height - self.pickerHeight - 44, width: view.width, height: self.pickerHeight + 44))
        view.addSubview(containerView)
        
        toolBar = UIToolbar.init()
        
        cancelButton = UIButton.init(frame: .init(x: 0, y: 0, width: 40, height: 44))
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = .font(fontSize: 15, fontName: .PingFMedium)
                
        let titleLable = UILabel.init(frame: .init(x: 0, y: 0, width: view.width - 80, height: 44))
        titleLable.font = .font(fontSize: 15, fontName: .PingFMedium)
        titleLable.textAlignment = .center
        titleLable.textColor = .black
        titleLable.text = titleDes

        doneButton = UIButton.init(frame: .init(x: 0, y: 0, width: 40, height: 44))
        doneButton.setTitle(okTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.setTitleColor(okTitleColor, for: .normal)
        doneButton.titleLabel?.font = .font(fontSize: 15, fontName: .PingFMedium)

        toolBar.items = [UIBarButtonItem.init(customView: cancelButton),
                         UIBarButtonItem.init(customView: titleLable),
                         UIBarButtonItem.init(customView: doneButton)]

        containerView.addSubview(toolBar)
        toolBar.frame = .init(x: 0, y: 0, width: view.width, height: 44)
        
        ///
        tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tapGes.delegate = self
        view.addGestureRecognizer(tapGes)
    }
    
    @objc func tapAction() {
        hidden(animotion: true, complement: nil)
    }
    
    @objc func cancelAction() {
        hidden(animotion: true, complement: nil)
    }
    
    @objc func doneAction() {

    }
        
    public func show(animotion: Bool) {
        if animotion {
            view.backgroundColor = RGB(10, 10, 10, 0.5)
            UIView.animate(withDuration: 0.25) { self.containerView.transform = .identity }
        }else {
            containerView.transform = .identity
        }
    }
    
    public func hidden(animotion: Bool, complement: (()->())?) {
        if animotion {
            UIView.animate(withDuration: 0.25, animations: {
                self.containerView.transform = .init(translationX: 0, y: self.pickerHeight + 44)
            }) { flag in
                if flag {
                    self.removeFromParaentViewController()
                    complement?()
                }
            }
        }else {
            containerView.transform = .init(translationX: 0, y: self.pickerHeight + 44)
            
            self.removeFromParaentViewController()
            complement?()
        }
    }
    
}

extension HCPicker: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !containerView.frame.contains(gestureRecognizer.location(in: view))
    }
}

