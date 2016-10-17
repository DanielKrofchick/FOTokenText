//
//  FOTokenTextField.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-10-17.
//
//

public class FOTokenTextField: UIView {
    
    public var textView = FOTokenTextView()
    public var leftView: UIView? = nil {
        didSet {
            if let leftView = leftView {
                addSubview(leftView)
                setNeedsLayout()
            }
        }
    }
    public var rightView: UIView? = nil {
        didSet {
            if let rightView = rightView {
                addSubview(rightView)
                setNeedsLayout()
            }
        }
    }
    
    public var clearButton: UIButton? = nil
    public var clearEnabled = false {
        didSet {
            if clearEnabled {
                clearButton = createClearButton()
                rightView = clearButton
            } else {
                clearButton?.removeFromSuperview()
                clearButton = nil
            }
        }
    }
    
    func createClearButton() -> UIButton {
        let button = UIButton(type: .System)
        button.setImage(UIImage(named: "delete.png")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 0)
    
        return button
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var leftS = CGSizeZero
        var rightS = CGSizeZero
        
        if let leftView = leftView {
            leftS = leftView.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
        }
        
        if let rightView = rightView {
            rightS = rightView.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
        }
        
        let textW = frame.width - leftS.width - rightS.width
        let textS = textView.sizeThatFits(CGSize(width: textW, height: CGFloat.max))
        let lineH = textView.heightOffset() + (textView.font?.lineHeight ?? 0)
        
        leftView?.frame = CGRect(x: 0, y: max(0, (lineH - leftS.height) / 2), width: leftS.width, height: leftS.height)
        textView.frame = CGRect(x: leftS.width, y: 0, width: textW, height: textS.height)
        rightView?.frame = CGRect(x: frame.width - rightS.width, y: max(0, (lineH - rightS.height) / 2), width: rightS.width, height: rightS.height)
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        var leftS = CGSizeZero
        var rightS = CGSizeZero
        
        if let leftView = leftView {
            leftS = leftView.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
        }
        
        if let rightView = rightView {
            rightS = rightView.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max))
        }
        
        let textW = size.width - leftS.width - rightS.width
        let textS = textView.sizeThatFits(CGSize(width: textW, height: CGFloat.max))
        
        return CGSize(width: size.width, height: max(textS.height, leftS.height, rightS.height))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
