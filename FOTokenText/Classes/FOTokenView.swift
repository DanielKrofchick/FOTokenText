//
//  FOTokenView.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-10-15.
//
//

public class FOTokenView: UIButton {
    
    public weak var textView: FOTokenTextView? = nil
    public var identifier = ""
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.orangeColor().CGColor
        layer.masksToBounds = true
        
        setTitleColor(UIColor.brownColor(), forState: .Normal)
        
        setBackgroundImage(UIImage(color: UIColor.lightGrayColor()), forState: .Normal)
        setBackgroundImage(UIImage(color: UIColor.blueColor()), forState: .Selected)
        setBackgroundImage(UIImage(color: UIColor.blueColor()), forState: [.Selected, .Highlighted])
        
        contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        addTarget(self, action: #selector(touchUpInside), forControlEvents: .TouchUpInside)
    }
    
    func touchUpInside() {
        if selected {
            textView?._removeToken(self)
        } else {
            textView?.clearSelectedToken()
            selected = true
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
