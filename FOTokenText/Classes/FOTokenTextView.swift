//
//  FOTokenTextView.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-07-14.
//
//

import Foundation

public class FOTokenTextView: UITextView {
    
    var tokens = [FOTokenButton]()
    var tokenSize = CGSizeZero
    
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
        
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    func doDelete() {
        if let token = tokens.last {
            removeToken(token)
        }
        
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    func addToken(text: String) {
        let token = newToken(text)
        tokens.append(token)
        addSubview(token)
    }
    
    func newToken(text: String) -> FOTokenButton {
        let token = FOTokenButton(type: .System)
        token.setTitle(text, forState: .Normal)
        token.titleLabel?.font = font
        
        return token
    }
    
    func removeToken(token: FOTokenButton) {
        if let index = tokens.indexOf(token) {
            token.removeFromSuperview()
            tokens.removeAtIndex(index)
        }
    }
    
    public override func layoutSubviews() {
        layoutTokens()
        
        if tokenSize == CGSizeZero {
            tokenSize = newToken("").sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
        }
        
        let (path, inset) = tokenExlusion()
        textContainer.exclusionPaths = [path]
        textContainerInset = UIEdgeInsetsMake(inset, 0, 0, 0)
        
        super.layoutSubviews()
    }
    
    func layoutTokens() {
        var p = CGPointZero
        
        for token in tokens {
            var s = token.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
            
            if p.x + s.width >= frame.width && p != CGPointZero {
                p.x = 0
                p.y += s.height
            }
            
            // Max width
            if p.x + s.width >= frame.width {
                s.width = frame.width - p.x
            }
            
            token.frame = CGRect(origin: p, size: s)
            
            p.x += s.width
        }
    }
    
    // Returns an exclusion path and a top inset. Inset is required beacuse of an ongoing bug with full width exclusion paths.
    // https://openradar.appspot.com/15761045
    func tokenExlusion() -> (UIBezierPath, CGFloat) {
        var tRect = CGRectZero
        var bRect = CGRectZero
        
        for token in tokens {
            if bRect == CGRectZero {
                // First
                bRect = CGRect(x: 0, y: 0, width: token.frame.maxX, height: token.frame.height)
            } else if token.frame.minY != bRect.minY {
                // New line
                tRect = CGRect(x: 0, y: 0, width: frame.width, height: token.frame.minY)
                bRect = CGRect(x: 0, y: token.frame.minY, width: token.frame.maxX, height: token.frame.height)
            } else {
                // Same line
                if token.frame.maxX + tokenSize.width >= frame.width {
                    bRect = CGRect(x: 0, y: token.frame.minY, width: frame.width, height: token.frame.height)
                } else {
                    bRect = CGRect(x: 0, y: token.frame.minY, width: token.frame.maxX, height: token.frame.height)
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
            inset += max(0, (tokenSize.height - font.lineHeight) / 2.0)
        }
        
        if bRect.width == frame.width {
            inset += bRect.height
        }
        
        print(inset)
        
        return (path, inset)
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        UIColor.blueColor().set()
        
        let (path, inset) = tokenExlusion()
        path.stroke()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func caretRectForPosition(position: UITextPosition) -> CGRect {
        var rect = super.caretRectForPosition(position)
        
        if let font = font {
            rect.size.height = font.lineHeight + 1.666666
        }
        
        return rect
    }
    
}

extension FOTokenTextView: UITextViewDelegate {
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            doReturn()
            
            return false
        }
        
        if text.characters.count == 0 {
            doDelete()
            
            return false
        }
        
        return true
    }
    
}

extension FOTokenTextView: NSLayoutManagerDelegate {
    
    public func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        var spacing = CGFloat(0)
        
        if let font = font {
            spacing = (tokenSize.height - font.lineHeight) / 2.0 + font.lineHeight
        }
        
        return spacing
    }
    
}

class FOTokenButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.orangeColor().CGColor
        setTitleColor(UIColor.brownColor(), forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}