//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTitle()
    }
    
    
    func updateTitle() {
        titleLabel.text = ""
        let titleText = K.flashChat
        var count = 0.0
        
        for txt in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * count, repeats: false) { timer in
                self.titleLabel.text?.append(txt)
            }
            count+=1
        }
    }

}
