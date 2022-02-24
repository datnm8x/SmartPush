//
//  MainViewController.swift
//  SmartPush Framework
//
//  Created by Dat Ng on 16/02/2022.
//  Copyright © 2022 Nguyen Mau Dat. All rights reserved.
//

import UIKit
import SmartPush

class MainViewController: UIViewController {
    // MARK: - Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func sendTestCallClicked() {
        SmartPush.connectCertificate(path: Bundle.main.path(forResource: "Your_certificate_file.p12", ofType: nil)! , password: "Your_certificate_pass")
        SmartPush.sendPush(payload: ["Test": 1], toToken: "your device token", pushType: .voIP) { result in
            switch result {
                case .success:
                    print("Pushed success!")
                case .failed(let string):
                    print("Push error: \(string)")
            }
        }
    }
}
