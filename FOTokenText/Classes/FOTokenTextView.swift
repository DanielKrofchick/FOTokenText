//
//  FOTokenTextView.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-07-14.
//
//

import Foundation

public protocol FOTokenTextViewProtocol {
    func newToken(textView: FOTokenTextView, text: String) -> FOTokenView
    func didRemove(token: FOTokenView)
    func didAdd(token: FOTokenView)
}

public class FOTokenTextView: UITextView {
    
    var tokens = [FOTokenView]()
    var tokenHeight = CGFloat(0)
    public var tokenEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    public var debug = false
    public var tokenDelegate: FOTokenTextViewProtocol? = nil
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        delegate = self
        layoutManager.delegate = self
        
        text = " "
        setNeedsLayout()
        layoutIfNeeded()
        text = ""
    }
    
    func doReturn() {
        addToken(text)
        text = nil
    }
    
    func doDelete() {
        if let token = tokens.last {
            if token.selected {
                removeToken(token)
            } else  {
                token.selected = true
            }
        }
    }
    
    func addToken(text: String, animated: Bool = false) {
        let token = newToken(text)
        token.alpha = 0
        tokens.append(token)
        addSubview(token)
        
        setNeedsLayout()
        UIView.animateWithDuration(animated ? 0.3 : 0, animations: {
            self.layoutIfNeeded()
        }, completion: { (finished) in
            token.alpha = 1
            self.tokenDelegate?.didAdd(token)
            if self.debug {
                self.setNeedsDisplay()
            }
        })
    }
    
    func newToken(text: String) -> FOTokenView {
        if let tokenDelegate = tokenDelegate {
            let token = tokenDelegate.newToken(self, text: text)
            token.textView = self
            
            return token
        } else {
            let token = FOTokenView(type: .System)
            token.setTitle(text, forState: .Normal)
            token.titleLabel?.font = font
            token.textView = self
            
            return token
        }
    }
    
    func removeToken(token: FOTokenView, animated: Bool = true) {
        if let index = tokens.indexOf(token) {
            token.removeFromSuperview()
            tokens.removeAtIndex(index)
            
            setNeedsLayout()
            UIView.animateWithDuration(animated ? 0.3 : 0, animations: {
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.tokenDelegate?.didRemove(token)
                if self.debug {
                    self.setNeedsDisplay()
                }
            })
        }
    }
    
    public override func layoutSubviews() {
        layoutTokens()
        
        if tokenHeight == 0 {
            tokenHeight = newToken("").sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max)).height
        }
        
        let (paths, inset) = tokenExlusions()
        textContainer.exclusionPaths = paths
        textContainerInset = UIEdgeInsetsMake(inset, 0, 0, 0)
        
        super.layoutSubviews()
    }
    
    func layoutTokens() {
        var p = CGPoint(x: 0, y: tokenEdgeInsets.top)
        
        for (index, token) in tokens.enumerate() {
            var s = token.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
            
            // New line
            if p.x + s.width + tokenEdgeInsets.left + tokenEdgeInsets.right >= frame.width && index != 0 {
                p.x = 0
                p.y += s.height + tokenEdgeInsets.top
            }
            
            // Max width
            if p.x + s.width + tokenEdgeInsets.left + tokenEdgeInsets.right >= frame.width {
                s.width = frame.width - p.x - tokenEdgeInsets.left - tokenEdgeInsets.right
            }
            
            p.x += tokenEdgeInsets.left
            
            token.frame = CGRect(origin: p, size: s)
            
            p.x += s.width
        }
    }
    
    // Returns an exclusion path and a top inset. Inset is required beacuse of an ongoing bug with full width exclusion paths.
    // https://openradar.appspot.com/15761045
    func tokenExlusions() -> ([UIBezierPath], CGFloat) {
        var tRect = CGRect(x: 0, y: 0, width: frame.width, height: tokenEdgeInsets.top)
        var bRect = CGRectZero
        
        for (index, token) in tokens.enumerate() {
            if index == 0 {
                // First
                tRect = CGRect(x: 0, y: 0, width: frame.width, height: token.frame.minY)
                bRect = CGRect(x: 0, y: tokenEdgeInsets.top, width: token.frame.maxX + tokenEdgeInsets.left, height: token.frame.height)
            } else if token.frame.minY != bRect.minY {
                // New line
                tRect = CGRect(x: 0, y: 0, width: frame.width, height: token.frame.minY)
                bRect = CGRect(x: 0, y: token.frame.minY, width: token.frame.maxX + tokenEdgeInsets.left, height: token.frame.height)
            } else {
                // Same line
                let tokenSize = token.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
                
                if token.frame.maxX + tokenSize.width >= frame.width {
                    bRect = CGRect(x: 0, y: token.frame.minY, width: frame.width, height: token.frame.height)
                } else {
                    bRect = CGRect(x: 0, y: token.frame.minY, width: token.frame.maxX + tokenEdgeInsets.left, height: token.frame.height)
                }
            }
        }
        
        let path = UIBezierPath()
        path.lineWidth = 4

        path.moveToPoint(CGPointZero)

        if tRect == CGRectZero {
            path.addLineToPoint(CGPoint(x: bRect.maxX, y: 0))
            path.addLineToPoint(CGPoint(x: bRect.maxX, y: bRect.maxY))
        } else {
            path.addLineToPoint(CGPoint(x: tRect.maxX, y: 0))
            path.addLineToPoint(CGPoint(x: tRect.maxX, y: tRect.maxY))
            path.addLineToPoint(CGPoint(x: bRect.maxX, y: tRect.maxY))
            path.addLineToPoint(CGPoint(x: bRect.maxX, y: bRect.maxY))
        }
        
        path.addLineToPoint(CGPoint(x: 0, y: bRect.maxY))
        path.addLineToPoint(CGPointZero)
        
        var inset = tRect.maxY
        
        if let font = font {
            inset += max(0, (tokenHeight - font.lineHeight) / 2.0)
        }
        
        if bRect.width >= frame.width {
            inset += bRect.height
        }
        
        return ([path], inset)
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if debug {
            UIColor.blueColor().set()
            
            let (paths, inset) = tokenExlusions()
            
            for path in paths {
                path.stroke()
            }
            
            if let c = UIGraphicsGetCurrentContext() {
                let contentRect = CGRect(origin: CGPointZero, size: contentSize)
                CGContextSetStrokeColorWithColor(c, UIColor.redColor().CGColor)
                CGContextStrokeRect(c, contentRect)
            }
        }
    }
    
    public override var contentSize: CGSize {
        get {
            var s = super.contentSize
            
            if let font = font where !text.isEmpty {
                s.height -= (tokenHeight - font.lineHeight) / 2.0 + font.lineHeight
            }
            
            return s
        }
        set {
            super.contentSize = newValue
        }
    }
    
    public override func caretRectForPosition(position: UITextPosition) -> CGRect {
        var rect = super.caretRectForPosition(position)
        
        if let font = font {
            rect.size.height = font.lineHeight + 1.666666
        }
        
        return rect
    }
    
    func clearSelectedToken() {
        for token in tokens {
            if token.selected {
                token.selected = false
            }
        }
    }
    
    // Disable magnifying glass. Interferes with tokens.
    public override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer is UILongPressGestureRecognizer {
            gestureRecognizer.enabled = false
        }
        
        super.addGestureRecognizer(gestureRecognizer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FOTokenTextView: UITextViewDelegate {
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            doReturn()
            
            return false
        }
        
        if text.characters.count == 0 && textView.text.characters.count == 0 {
            doDelete()
            
            return false
        }
        
        clearSelectedToken()
        
        return true
    }
    
    public func textViewDidChange(textView: UITextView) {
        if debug {
            setNeedsDisplay()
        }
    }
    
}

extension FOTokenTextView: NSLayoutManagerDelegate {
    
    public func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        var spacing = CGFloat(0)
        
        if let font = font {
            spacing = (tokenHeight - font.lineHeight) / 2.0 + font.lineHeight
        }
        
        return spacing
    }
    
}

public class FOTokenView: UIButton {
    
    public weak var textView: FOTokenTextView? = nil
    
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
            textView?.removeToken(self)
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
