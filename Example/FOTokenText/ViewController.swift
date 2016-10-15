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
    
    let textView = FOTokenTextView()
    let EI = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = UIColor.greenColor().CGColor
        textView.layer.borderWidth = 1
        textView.debug = true
        textView.tokenDelegate = self
        view.addSubview(textView)
        
        NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidChangeNotification, object: textView, queue: .mainQueue()) {
            [weak self] note in
            if let this = self {
                this.view.setNeedsLayout()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let textW = view.frame.width - EI.left - EI.right
        let textS = textView.sizeThatFits(CGSize(width: textW, height: CGFloat.max))
        
        print(textS)
        
        textView.frame = CGRect(x: EI.left, y: EI.top, width: textW, height: textS.height)
    }
    
}

extension ViewController: FOTokenTextViewProtocol {
    
    func newToken(textView: FOTokenTextView, text: String) -> FOTokenView {
        let token = FOTokenView(type: .System)
        token.setTitle(text, forState: .Normal)
        token.titleLabel?.font = textView.font
        
        return token
    }
    
    func didAdd(token: FOTokenView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func didRemove(token: FOTokenView) {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func shouldAddOnReturn(text: String) -> Bool {
        return true
    }
    
    func shouldRemoveOnDelete(token: FOTokenView) -> Bool {
        return true
    }
    
}

class FOCustomToken: FOTokenView {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.purpleColor().CGColor
        layer.masksToBounds = true
        
        setTitleColor(UIColor.brownColor(), forState: .Normal)
        
        setBackgroundImage(UIImage(color: UIColor.yellowColor()), forState: .Normal)
        setBackgroundImage(UIImage(color: UIColor.greenColor()), forState: .Selected)
        setBackgroundImage(UIImage(color: UIColor.greenColor()), forState: [.Selected, .Highlighted])
        
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
            let rect = CGRect(origin: CGPointZero, size: size)
            
            CGContextSetFillColorWithColor(c, color.CGColor)
            CGContextFillRect(c, rect)
            
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        if let i = image?.CGImage {
            self.init(CGImage: i)
        } else {
            self.init()
        }
    }
    
}
