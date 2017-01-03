//
//  FOTokenTextField.swift
//  Pods
//
//  Created by Daniel Krofchick on 2016-10-17.
//
//

open class FOTokenTextField: UIView {
    
    open var textView = FOTokenTextView()
    open var leftView: UIView? = nil {
        didSet {
            if let leftView = leftView {
                addSubview(leftView)
                setNeedsLayout()
            }
        }
    }
    open var rightView: UIView? = nil {
        didSet {
            if let rightView = rightView {
                addSubview(rightView)
                setNeedsLayout()
            }
        }
    }
    
    open var clearButton: UIButton? = nil
    open var clearButtonMode: UITextFieldViewMode = .whileEditing {
        didSet {
            if clearButtonMode == .whileEditing {
                clearButton = createClearButton()
                rightView = clearButton
                updateClearButton()
            } else {
                clearButton?.removeFromSuperview()
                clearButton = nil
            }
        }
    }
    
    func createClearButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "FOToken_delete.png")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 0)
    
        return button
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView.backgroundColor = UIColor.clear
        addSubview(textView)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: textView, queue: .main) {
            [weak self] note in
            self?.updateClearButton()
        }
        
        defer {
            clearButtonMode = .whileEditing
        }
    }
    
    
    func updateClearButton() {
        if clearButtonMode == .whileEditing {
            clearButton?.isHidden = textView.text.isEmpty
        }
    }
    
    open override func becomeFirstResponder() -> Bool {
        let r = super.becomeFirstResponder()
        
        updateClearButton()
        
        return r
    }
    
    open override func resignFirstResponder() -> Bool {
        let r = super.resignFirstResponder()
        
        updateClearButton()
        
        return r
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var leftS = CGSize.zero
        var rightS = CGSize.zero
        
        if let leftView = leftView {
            leftS = leftView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        }
        
        if let rightView = rightView {
            rightS = rightView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        }
        
        let textW = frame.width - leftS.width - rightS.width
        let textS = textView.sizeThatFits(CGSize(width: textW, height: CGFloat.greatestFiniteMagnitude))
        let lineH = textView.heightOffset() + (textView.font?.lineHeight ?? 0)
        
        leftView?.frame = CGRect(x: 0, y: max(0, (lineH - leftS.height) / 2), width: leftS.width, height: leftS.height)
        textView.frame = CGRect(x: leftS.width, y: 0, width: textW, height: textS.height)
        rightView?.frame = CGRect(x: frame.width - rightS.width, y: max(0, (lineH - rightS.height) / 2), width: rightS.width, height: rightS.height)
        updateClearButton()
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var leftS = CGSize.zero
        var rightS = CGSize.zero
        
        if let leftView = leftView {
            leftS = leftView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        }
        
        if let rightView = rightView {
            rightS = rightView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        }
        
        let textW = size.width - leftS.width - rightS.width
        let textS = textView.sizeThatFits(CGSize(width: textW, height: CGFloat.greatestFiniteMagnitude))
        
        return CGSize(width: size.width, height: max(textS.height, leftS.height, rightS.height))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
