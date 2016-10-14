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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderColor = UIColor.greenColor().CGColor
        textView.layer.borderWidth = 1
        textView.debug = true
        textView.tokenDelegate = self
        view.addSubview(textView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.frame = CGRect(x: 20, y: 20, width: view.frame.width - 20 * 2, height: view.frame.height - 20 * 2)
    }
    
}

extension ViewController: FOTokenTextViewProtocol {
    
    func newToken(textView: FOTokenTextView, text: String) -> FOTokenView {
        let token = FOCustomToken()
        token.setTitle(text, forState: .Normal)
        token.titleLabel?.font = textView.font
        
        return token
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
