//
//  TestTableViewController.swift
//  SDKtest
//
//  Created by Alvaro Santiesteban on 5/28/17.
//  Copyright © 2017 3vts. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKCoreKit

class TestTableViewController: UITableViewController {
    
    var familyDict: [[String:AnyObject]]!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "familyCell")!
        if let userID = familyDict[indexPath.row]["id"] as? String {
            getProfileImage(userID, completion: {
                (profileImage: UIImage) in
                cell.imageView?.image = profileImage
                cell.textLabel?.text = self.familyDict[indexPath.row]["name"] as? String
                if let details = cell.detailTextLabel{
                    details.text = self.familyDict[indexPath.row]["relationship"]?.capitalized
                }
                
            })
        }
        return cell
    }
    
    func getProfileImage (_ userID: String, completion: @escaping (_ profileImage: UIImage) -> Void) {
        FBSDKGraphRequest(graphPath: "/\(userID)/picture", parameters: ["type": "small", "redirect": "false"]).start(completionHandler: {(connection, result, error) -> Void in
            if let result = result as! [String:AnyObject]? {
                
                if let imageUrlString = result["data"]?["url"] as? String {
                    let imageURL = URL(string: imageUrlString)
                    if let imageData = try? Data(contentsOf: imageURL!) {
                        completion(UIImage(data: imageData)!)
                    }
                }
            }
        })
    }
}
