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
    let EI = UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftView = UILabel()
        leftView.textColor = UIColor.black
        leftView.text = NSLocalizedString("To", comment: "Search field") + ": "
        leftView.font = UIFont.systemFont(ofSize: 15)
        
        textView.textView.font = UIFont.systemFont(ofSize: 15)
        textView.textView.tokenDelegate = self
        textView.leftView = leftView
        textView.clearButtonMode = .whileEditing
        textView.clearButton?.addTarget(self, action: #selector(clearTap), for: .touchUpInside)
        view.addSubview(textView)
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: textView, queue: .main) {
            [weak self] note in
            if let this = self {
                this.view.setNeedsLayout()
            }
        }
    }
    
    @objc func clearTap() {
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
        token.setTitle(text, for: .normal)
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
    
}
