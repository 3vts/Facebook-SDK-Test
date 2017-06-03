//
//  ViewController.swift
//  SDKtest
//
//  Created by Alvaro Santiesteban on 5/27/17.
//  Copyright © 2017 3vts. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKShareKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    
    var familyDetails: [[String:AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.FBLoginButton.delegate = self
        self.FBLoginButton.readPermissions = ["public_profile", "user_relationships"]
        self.FBLoginButton.loginBehavior = .systemAccount
    }
    
    @IBAction func testGraphRequest(_ sender: UIButton) {
        returnUsersData(completion: {(result)->Void in
            self.nextScreen()
        })
    }
    
    func nextScreen() {
        performSegue(withIdentifier: "segueTableView", sender: self)
    }
    
    func returnUsersData(completion:@escaping (_ result:[String:AnyObject])->Void) {
        
        FBSDKGraphRequest(graphPath: "/me/family", parameters: ["fields": "name, relationship"]).start(completionHandler: {(connection, result, error) -> Void in
            if let result = result as! [String:AnyObject]? {
                if let familyDictionary = result["data"] as? [[String:AnyObject]]{
                    self.familyDetails = familyDictionary
                }
                completion(result)
            }
        })
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TestTableViewController
        controller.familyDict = self.familyDetails
        
    }
    
    
}
