//
//  FOTokenView.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-10-15.
//
//

open class FOTokenView: UIButton {
    
    open weak var textView: FOTokenTextView? = nil
    open var identifier = ""
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.orange.cgColor
        layer.masksToBounds = true
        
        setTitleColor(UIColor.brown, for: UIControlState())
        
        setBackgroundImage(UIImage(color: UIColor.lightGray), for: UIControlState())
        setBackgroundImage(UIImage(color: UIColor.blue), for: .selected)
        setBackgroundImage(UIImage(color: UIColor.blue), for: [.selected, .highlighted])
        
        contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    func touchUpInside() {
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
