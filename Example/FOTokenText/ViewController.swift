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
        view.addSubview(textView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.frame = CGRect(x: 20, y: 20, width: view.frame.width - 20 * 2, height: view.frame.height - 20 * 2)
    }
    
}

