//
//  MenuTableVC.swift
//  DishUpApp
//
//  Created by James White on 7/16/15.
//  Copyright (c) 2015 James White. All rights reserved.
//

import Foundation
class MenuTableVC: UITableViewController {
    var TableArray = [String]()
    override func viewDidLoad() {
        TableArray = ["Sign In/Sign Up", "Browse Dishes", "Browse Restaurants", "About"]
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = TableArray[indexPath.row]
        return cell
    }
}