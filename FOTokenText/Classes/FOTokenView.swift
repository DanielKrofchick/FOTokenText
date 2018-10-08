//
//  FOTokenView.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-10-15.
//
//

import UIKit

open class FOTokenView: UIButton {
    
    open weak var textView: FOTokenTextView? = nil
    open var identifier = ""
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        layer.borderWidth =  1.0 / UIScreen.main.scale
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        
        setTitleColor(UIColor.black, for: .normal)
        
        setBackgroundImage(UIImage(color: UIColor(red: 0.827, green: 0.906, blue: 920, alpha: 1)), for: .normal)
        setBackgroundImage(UIImage(color: UIColor(red: 0.435, green: 0.690, blue: 0.937, alpha: 1)), for: .selected)
        setBackgroundImage(UIImage(color: UIColor(red: 0.435, green: 0.690, blue: 0.937, alpha: 1)), for: [.selected, .highlighted])
        
        contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc func touchUpInside() {
        if isSelected {
            textView?._removeToken(self)
        } else {
            textView?.clearSelectedToken()
            isSelected = true
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
