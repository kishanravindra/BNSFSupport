//
//  RoundedTextField.swift
//  BNSFVVIPSupport
//
// Created by KishanRavindra on 23/11/21.
//

import Foundation
import UIKit


@IBDesignable
class RoundedTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var paddingLeft: CGFloat {
           get {
               return leftView!.frame.size.width
           }
           set {
               let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
               leftView = paddingView
               leftViewMode = .always
           }
       }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
            layer.masksToBounds = self.cornerRadius > 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor?.cgColor
    }
}

