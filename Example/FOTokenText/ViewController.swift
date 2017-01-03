//
//  ViewController.swift
//  FOTokenText
//
//  Created by Daniel Krofchick on 07/14/2016.
//  Copyright (c) 2016 Daniel Krofchick. All rights reserved.
//

import UIKit
import FOTokenText

class ViewController: UIViewController {
    
    let textView = FOTokenTextField()
    let EI = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftView = UILabel()
        leftView.textColor = UIColor.orange
        leftView.text = NSLocalizedString("To", comment: "Search field") + ": "
        leftView.font = UIFont.systemFont(ofSize: 15)
        
        textView.textView.layer.borderColor = UIColor.green.cgColor
        textView.textView.layer.borderWidth = 1
        textView.textView.debug = true
        textView.textView.tokenDelegate = self
        textView.leftView = leftView
        textView.clearButtonMode = .whileEditing
        textView.clearButton?.addTarget(self, action: #selector(clearTap), for: .touchUpInside)
        view.addSubview(textView)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: textView, queue: .main) {
            [weak self] note in
            if let this = self {
                this.view.setNeedsLayout()
            }
        }
    }
    
    func clearTap() {
        textView.textView.text = nil
        textView.setNeedsLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let textW = view.frame.width - EI.left - EI.right
        let textS = textView.sizeThatFits(CGSize(width: textW, height: CGFloat.greatestFiniteMagnitude))
        
        textView.frame = CGRect(x: EI.left, y: EI.top, width: textW, height: textS.height)
    }
    
}

extension ViewController: FOTokenTextViewProtocol {
    
    func newToken(_ textView: FOTokenTextView, text: String) -> FOTokenView {
        let token = FOTokenView(type: .system)
        token.setTitle(text, for: UIControlState())
        token.titleLabel?.font = textView.font
        
        return token
    }
    
    func didAdd(_ token: FOTokenView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func didRemove(_ token: FOTokenView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func shouldAddOnReturn(_ text: String) -> Bool {
        return true
    }
    
    func shouldRemoveOnDelete(_ token: FOTokenView) -> Bool {
        return true
    }
    
}

class FOCustomToken: FOTokenView {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.purple.cgColor
        layer.masksToBounds = true
        
        setTitleColor(UIColor.brown, for: UIControlState())
        
        setBackgroundImage(UIImage(color: UIColor.yellow), for: UIControlState())
        setBackgroundImage(UIImage(color: UIColor.green), for: .selected)
        setBackgroundImage(UIImage(color: UIColor.green), for: [.selected, .highlighted])
        
        contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIImage {
    
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContext(size)
        
        var image: UIImage? = nil
        
        if let c = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: CGPoint.zero, size: size)
            
            c.setFillColor(color.cgColor)
            c.fill(rect)
            
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        if let i = image?.cgImage {
            self.init(cgImage: i)
        } else {
            self.init()
        }
    }
    
}
