//
//  ViewController.swift
//  AdvanceSearchForTwitter
//
//  Created by Ender Güzel on 23.09.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import OAuthSwift

class SignInViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        signInButton.layer.cornerRadius = 5
    }
    
    // MARK: Actions
    @IBAction func signInPressed(_ sender: UIButton) {
        TwitterAPI.authorize(viewController: self, completion: handleAuthorizeResponse(success:error:))
    }
    
    @objc func handleAuthorizeResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "homePage", sender: self)
        } else {
            displayAlert(title: "Authorization Error", with: "Twitter Authorization did not completed successfully.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Logout"
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }

}

